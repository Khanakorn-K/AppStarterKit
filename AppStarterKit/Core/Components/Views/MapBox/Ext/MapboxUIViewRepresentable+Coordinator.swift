//
//  MapboxUIViewRepresentable+Coordinator.swift
//  JERTAM
//
//  Created by Chanchana on 16/7/2567 BE.
//

import Foundation
import Mapbox
import MapboxDirections
import Combine
import ClusterKit
import Logging





extension MapboxUIViewRepresentable {
    @MainActor
    class Coordinator {
        var mapView: MGLMapView? {
            didSet {
                mapboxPinUpdater?.mapView = mapView
                mapboxRouteUpdater?.mapView = mapView
                mapboxRoutePointUpdater?.mapView = mapView
                mapboxDirectionBuider?.mapView = mapView
               
                bindingButtonOpenExpandMap()
            }
        }
        var parent:MapboxUIViewRepresentable
        
        var tapPin = MGLPointAnnotation()
        
        var cancellable = Set<AnyCancellable>()
        
        let mapboxProxy: MapboxProxy? = .init()
        var mapboxPinUpdater: MapboxPinUpdater<PinContent, PinCluster, PinResponseModel>?
        var mapboxRouteUpdater: MapboxRouteUpdater?
        var mapboxRoutePointUpdater: MapboxRoutePointUpdater<RoutePin, RoutePinResponseModel>?
        var mapboxDirectionBuider: MapboxDirectionBuider?
        
        var isRegionChange = false
        private var hasBaindingExpandMapButton = false
        private weak var configuration: MapViewConfigurationViewModel?
        
        private lazy var logger: Logger = {
            Logger(label: "\(self)")
        }()
        
        init(parent: MapboxUIViewRepresentable,
             configuration: MapViewConfigurationViewModel?) {
            self.parent = parent
            self.configuration = configuration
            mapboxPinUpdater = .init(mapView: mapView,
                                     mapboxProxy: mapboxProxy,
                                     configuration: configuration,
                                     isShowPin: parent.isShowPin,
                                     pinView: parent.pinContent,
                                     urlForPin: parent.urlForPin,
                                     pinSize: parent.pinSize,
                                     clusterSize: parent.clusterSize,
                                     pinCluster: parent.pinCluster,
                                     onPinUpdate: {
                parent.onPinUpdate?()
            },
                                     annotationFor: parent.annotationFor)
            
            mapboxRouteUpdater = .init(mapView: mapView,
                                       mapboxProxy: mapboxProxy,
                                       configuration: configuration,
                                       isShowRoute: parent.isShowRoute,
                                       urlForRouteLine: parent.urlForRouteLine)
            
            mapboxRoutePointUpdater = .init(mapView: mapView,
                                            mapboxProxy: mapboxProxy,
                                            configuration: configuration,
                                            isShowPoint: parent.isShowPoint,
                                            urlForRoutePin: parent.urlForRoutePin,
                                            annotationForRoutePin: parent.annotationForRoutePin,
                                            viewForRoutePin: parent.viewForRoutePin,
                                            routePinSize: parent.routePinSize)
            
            mapboxDirectionBuider = .init(mapView: mapView)
            
            
            binding()
        }
        
        private func bindingButtonOpenExpandMap() {
            guard hasBaindingExpandMapButton.negated
            else { return }
            
            hasBaindingExpandMapButton = true
            
            setUpButtonExpand()
            
            mapView?.attributionButton.removeTarget(nil,
                                                    action: nil,
                                                    for: .allEvents)
            mapView?.attributionButton.addTarget(self, action: #selector(Coordinator.onTapAttributionButton), for: .touchUpInside)
        }
        
        @objc func onTapAttributionButton() {
            parent.didTapExpand?()
        }
        
        private func setUpButtonExpand() {
            mapView?.logoView.isHidden = true
            
            if let image = parent.attributionButtonImage {
                mapView?.attributionButton.setImage(image,
                                                    for: .normal)
            }
          
            mapView?.attributionButton.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
            mapView?.attributionButton.tintColor = .white
            mapView?.attributionButton.backgroundColor = Asset.Color.colorMain.color
            mapView?.attributionButton.layer.cornerRadius = (mapView?.attributionButton.height ?? 1) / 2
            mapView?.attributionButton.isHidden = true
        }
        
        private func binding() {
            configuration?.forceClearTapGroundPin = {[weak self] in
                guard let exitingPin = self?.mapView?.annotations?.first(where: {$0.title == self?.parent.pinMarkKey})
                else { return }
                
                self?.mapView?.removeAnnotation(exitingPin)
                
            }
            
            configuration?.forceRefreshHandler = {[weak self] in
                
                self?.mapView?.setZoomLevel((self?.mapView?.zoomLevel ?? 19) - 1, animated: true)
            }
            
            configuration?.didRequestDirection = {[weak self] waypoints in
                Task {
                    try? await self?.mapboxDirectionBuider?.createDirection(waypoint: waypoints)
                }
            }
            
            configuration?.mapView = { [weak self] in
                return self?.mapView
            }
            
            mapboxProxy?.didFinishLoading
                .receive(on: DispatchQueue.main )
                .sink(receiveValue: { [weak self] _ in
                    self?.setUpDefaultZoom()
                    self?.handleDidFinishLoadingMap()
                })
                .store(in: &cancellable)
            
            mapboxProxy?.regionWillChangeWith
                .receive(on: DispatchQueue.main )
                .sink(receiveValue: { [weak self] _ in
                    self?.updateVisibleChange()
                    
                    self?.isRegionChange = true
                })
                .store(in: &cancellable)
            
            mapboxProxy?.regionDidChangeAnimated
                .receive(on: DispatchQueue.main )
                .sink(receiveValue: { [weak self] _ in
                    self?.updateVisibleChange()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self?.isRegionChange = false
                    }
                })
                .store(in: &cancellable)
            
            mapboxProxy?.viewFor = { [weak self] mapView, annotation in
                guard annotation is MGLPointAnnotation || annotation is CKCluster
                else {
                    return nil
                }
                
                var annotationView: MGLAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: annotation.reuseIdentifier)
                
                // if the annotation image hasn‘t been used yet, initialize it here with the reuse identifier
                if annotationView == nil {
                    // lookup the image for this annotation
                    
                    if let annotation = annotation as? CKCluster{
                        annotationView = self?.mapboxPinUpdater?.viewForAnnotation(annotation: annotation)
                    } else if annotation.title == "waypoint" {
                        return nil
                    } else if annotation.title != self?.parent.pinMarkKey{
                        annotationView = self?.mapboxRoutePointUpdater?.viewForAnnotationRoutePoint(annotation: annotation)
                    } else {
                        self?.logger.error(.init(stringLiteral: "type anotation not correct"))
                    }
                    
                }
                
                
                return annotationView
            }
            
            mapboxProxy?.didSelect
                .compactMap{ $0 as? CKCluster }
                .receive(on: DispatchQueue.main )
                .sink(receiveValue: { [weak self] ck in
                    let pinCount = ck.count
                    
                    if pinCount > 1 {
                        let annotations = (ck.annotations as [AnyObject] )
                            .compactMap{ $0 as?  UserInfoMGLPointAnnotationView}.compactMap{ $0 }
                        self?.parent.didSelectCluster?(annotations)
                    } else if pinCount == 1, let annotation = ck.firstAnnotation as? UserInfoMGLPointAnnotationView{
                        self?.parent.didSelectPin?(annotation)
                    }
                   
                })
                .store(in: &cancellable)
        }
        
        private func setUpDefaultZoom() {
            mapView?.minimumZoomLevel = 10
            mapView?.maximumZoomLevel = 21
        }
        
        @objc func handleMapTap(_ gesture: UITapGestureRecognizer) {
            // Convert tap location (CGPoint) to geographic coordinate (CLLocationCoordinate2D).
            let tapPoint: CGPoint = gesture.location(in: mapView)
            guard let tapCoordinate: CLLocationCoordinate2D = mapView?.convert(tapPoint,
                                                                               toCoordinateFrom: nil)
            else { return }

            guard parent.didTapGround != nil
            else { return }
           
            tapPin.coordinate = tapCoordinate
            tapPin.title = parent.pinMarkKey
            
            if let exitingPin = mapView?.annotations?.first(where: {$0.title == parent.pinMarkKey}){
                mapView?.removeAnnotation(exitingPin)
                parent.didClearTapGround?()
            
            }else{
                mapView?.addAnnotation(tapPin)
                parent.didTapGround?(tapCoordinate)
              
                
                mapView?.setCenter(tapCoordinate,
                                   animated: true)
                
            }
        }
    }
}

extension MapboxUIViewRepresentable.Coordinator {

    
  
 
    func handleDidFinishLoadingMap() {
        
        var coord:CLLocationCoordinate2D = .init(latitude: 13.750632,longitude: 100.576161)
        
        if let userLocation = mapView?.userLocation {
            coord = userLocation.coordinate
        }
        
        mapView?.setCenter(coord,
                           zoomLevel: ProcessInfo.processInfo.isPreview && parent.coordinateFocus == nil ? 19 : parent.firstZoom ?? 17,
                           animated: false)
        if let mapView = self.mapView {
            self.parent.didFinishLoadMap?(mapView)
        }
        
        
        if parent.didTapExpand != nil, parent.isShowButtonExpandMap {
            mapView?.attributionButton.isHidden = false
        }
      
        guard let focusCoordinate = parent.coordinateFocus
        else { return }
        let camera = MGLMapCamera()
        camera.centerCoordinate = focusCoordinate
        camera.viewingDistance = 150
        
        mapView?.setCamera(camera,
                           withDuration: 3.5,
                           animationTimingFunction: nil,
                           edgePadding: .zero)
        
    }
    
    private func updateVisibleChange() {
        guard let mapView = self.mapView
        else { return }
        
        if let userLocation = mapView.userLocation {
         
            // Calculate visible bounds around the user's location
            let userCoordinate = userLocation.coordinate
            // Define a desired distance (in meters) around the user's location to be visible on the map
            let desiredDistance: CLLocationDistance = 10 // Adjust as needed

            // Calculate the span in degrees based on the desired distance
            let metersPerDegree: CLLocationDistance = 111000 // Approximate value
            let latitudeSpan = desiredDistance / metersPerDegree
            let longitudeSpan = latitudeSpan / cos(userLocation.coordinate.latitude * .pi / 180)

            // Calculate the bounds based on the user's location and the span
            let northeastCoordinate = CLLocationCoordinate2D(latitude: userCoordinate.latitude + latitudeSpan,
                                                             longitude: userCoordinate.longitude + longitudeSpan)
            
            let southwestCoordinate = CLLocationCoordinate2D(latitude: userCoordinate.latitude - latitudeSpan,
                                                             longitude: userCoordinate.longitude - longitudeSpan)

      
            // Create the MGLCoordinateBounds
            let bounds = MGLCoordinateBounds(sw: southwestCoordinate, ne: northeastCoordinate)

            let isUserLocationVisible = MGLCoordinateInCoordinateBounds(mapView.centerCoordinate, bounds)
          
            parent.userLocationVisibleChange?(isUserLocationVisible)
        }
    }
}

