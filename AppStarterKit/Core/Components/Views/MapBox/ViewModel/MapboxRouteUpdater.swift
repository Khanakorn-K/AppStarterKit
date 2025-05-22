//
//  MapboxRouteUpdater.swift
//  JERTAM
//
//  Created by Chanchana on 16/7/2567 BE.
//

import Foundation
import Mapbox
import Combine

@MainActor
class MapboxRouteUpdater: ObservableObject {
    private var isDev: String {
        EndPointManager.isDev ? "dv" : ""
    }
    
    @Published var routeCoordinates: [CLLocationCoordinate2D] = []
    
    let isShowRoute: Bool
    
    weak var mapView: MGLMapView?
    var cancellable: Set<AnyCancellable> = .init()
    
    weak var configuration: MapViewConfigurationViewModel?
    weak var mapboxProxy: MapboxProxy?
    var task: Task<(), any Error>?
    var urlForRouteLine: ((_ bbox: String) -> (String))?
    
    init(mapView: MGLMapView?,
         mapboxProxy: MapboxProxy?,
         configuration: MapViewConfigurationViewModel?,
         isShowRoute: Bool,
         urlForRouteLine: ((_ bbox: String) -> (String))?
    ) {
        self.mapboxProxy = mapboxProxy
        self.mapView = mapView
        self.configuration = configuration
        self.isShowRoute = isShowRoute
        self.urlForRouteLine = urlForRouteLine
        
        binding()
    }
    
    private func binding() {
        
        $routeCoordinates
            .filter{ [weak self] _ in self?.isShowRoute ?? true }
            .filter{[weak self] _ in self?.configuration?.isViewDisappear.negated ?? true }
            .throttle(for: .seconds(2), scheduler: DispatchQueue.main, latest: true)
//                .filter{[weak self] _ in self?.isRegionChange.negated ?? false }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {[weak self] listCoord in
                
                guard listCoord.count > 0
                else {
                    self?.clearPolyline()
                    return
                }
              
                self?.addRoute()
                
            })
            .store(in: &cancellable)
        
        mapboxProxy?.regionDidChangeAnimated
            .delay(for: .seconds(2), scheduler: DispatchQueue.main )
            .sink(receiveValue: { [weak self] _ in
                self?.update()
            })
            .store(in: &cancellable)
        
        mapboxProxy?.didFinishLoading
            .receive(on: DispatchQueue.main )
            .sink(receiveValue: { [weak self] _ in
                self?.update()
            })
            .store(in: &cancellable)
    }
    
    func update() {
        guard configuration?.isViewDisappear.negated ?? true
        else { return }
        
        guard let mapView = self.mapView
        else { return }
        
        task?.cancel()
        
        task = Task { [weak self] in
            do {
                let response = try await self?.getRoute(bbox: mapView.bboxString)
                
                let routeList: [CLLocationCoordinate2D] = response?.features.first?.geometry
                    .coordinates[safe: 0]?
                    .compactMap{
                        guard let lat = $0[safe: 1],
                              let lng = $0[safe: 0]
                        else { return nil}
                        
                        return CLLocationCoordinate2D(latitude: lat,
                                                      longitude: lng)
                    } ?? []
                
                
                DispatchQueue.main.async {
                    self?.routeCoordinates = routeList
                }
                
            } catch let urlError as URLError {
                self?.clearPolyline()
                print("urlError \(urlError) | \(urlError.userInfo)")
            }
        }
    }
    
    private func getRoute(bbox: String) async throws -> MapRouteResponseModel {
        let url = "https://layer.jertam.com/jertammap/ows?service=WFS&version=1.0.0&request=GetFeature&typename=\(isDev)jertammap:walkruntrailroute&outputFormat=application/json&srsname=EPSG:4326&bbox=\(bbox)"
        
       return try await MapboxAPICreator(url: (urlForRouteLine?(bbox) ?? url).url).build()
    }
    
    func addRoute(){
        guard let mapView = self.mapView
        else { return }
        
        guard routeCoordinates.count > 0
        else { return }
                
        let polylineFeature = MGLPolylineFeature(coordinates: routeCoordinates, count: UInt(routeCoordinates.count))
        // Customize the polyline's properties
        polylineFeature.attributes["strokeColor"] = Asset.Color.colorBlue.color
        polylineFeature.attributes["lineWidth"] = 5.0
        
        var polylineSource: MGLShapeSource?
        
        // Remove the existing polyline source if it exists
        if let existingSource = mapView.style?.source(withIdentifier: "polyline") as? MGLShapeSource {
            existingSource.shape = polylineFeature
            polylineSource = existingSource
        } else {
            // Add the polyline feature to your map
            polylineSource = MGLShapeSource(identifier: "polyline", features: [polylineFeature], options: nil)
            mapView.style?.addSource(polylineSource!)
        }
        
        guard let polylineSource = polylineSource
        else { return }
        
      
        
        // Remove the existing polyline layer if it exists
        if mapView.style?.layer(withIdentifier: "polyline-layer") as? MGLLineStyleLayer == nil{
            let polylineLayer = MGLLineStyleLayer(identifier: "polyline-layer", source: polylineSource)
            polylineLayer.lineJoin = NSExpression(forConstantValue: "round")
            polylineLayer.lineCap = NSExpression(forConstantValue: "round")
            polylineLayer.lineOpacity = NSExpression(forConstantValue: 0.5)

            // Apply styling properties
            polylineLayer.lineWidth = NSExpression(forKeyPath: "lineWidth")
            polylineLayer.lineColor = NSExpression(forKeyPath: "strokeColor")
    //            polylineLayer.lineDashPattern = NSExpression(forConstantValue: [2, 2])
            mapView.style?.addLayer(polylineLayer)
        }
    }

    private func clearPolyline() {
        guard let mapView = self.mapView
        else { return }
        
        // Remove the existing polyline source if it exists
        if let existingSource = mapView.style?.source(withIdentifier: "polyline") as? MGLShapeSource {
            mapView.style?.removeSource(existingSource)
        }
        
        if let layer = mapView.style?.layer(withIdentifier: "polyline-layer") {
            mapView.style?.removeLayer(layer)
        }
    }
}
