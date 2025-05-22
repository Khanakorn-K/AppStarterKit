//
//  MapboxUIViewRepresentable.swift
//  AppStarterKit
//
//  Created by Chanchana Koedtho on 26/9/2566 BE.
//

import Foundation
import Mapbox
import SwiftUI
import MapKit
import Kingfisher
import Combine
import SwifterSwift
import ClusterKit.Mapbox


class CustomMGLMapView: MGLMapView {
    deinit {
        print("map deinit")
    }
}

struct PinDefault: View {
    
    var body: some View {
        Circle()
            .fill(.red)
    }
}

enum MapboxResponseEmptyModel: Codable {
    case none
}


struct MapboxUIViewRepresentable<PinContent: View,
                                 PinCluster: View,
                                 PinResponseModel: Codable,
                                 RoutePin: View,
                                 RoutePinResponseModel: Codable>: UIViewRepresentable{
   
    var pinContent: (Any?) -> PinContent
    var pinCluster: (CKCluster) -> PinCluster
    var viewForRoutePin: (Any?) -> RoutePin
    
    let pinMarkKey = "mark-from-tap"
    
    @Weak var configuration: MapViewConfigurationViewModel?
    
    var coordinateFocus:CLLocationCoordinate2D?
    var firstZoom: CGFloat?
    var attributionButtonImage: UIImage?
    var isShowRoute: Bool = true
    var isShowPin: Bool = true
    var isShowPoint: Bool = true
    var isShowButtonExpandMap: Bool = true
    var layerURL: String?
    var pinSize: CGSize?
    var clusterSize: CGSize?
    var routePinSize: CGSize?
    
    
    var didSelectPin: ( (UserInfoMGLPointAnnotationView) -> Void )?
    var didTapGround: ( (CLLocationCoordinate2D) -> Void )?
    var didClearTapGround: ( () -> Void )?
    var didFinishLoadMap: ((MGLMapView)->())?
    var didTapExpand: (() -> Void)?
    var userLocationVisibleChange: ((Bool)->())?
    var onPinUpdate: (()->())?
    var didSetMap: ((MGLMapView)->())?
    var urlForPin: ((_ bbox: String) -> (String))?
    var didSelectCluster: (([UserInfoMGLPointAnnotationView])->())?
    
    var annotationFor: ((PinResponseModel?) -> ([MGLPointAnnotation]))?
    
    var urlForRoutePin: ((_ bbox: String) -> (String))?
    var annotationForRoutePin: ((RoutePinResponseModel?) -> ([MGLPointAnnotation]))?
    
    var urlForRouteLine: ((_ bbox: String) -> (String))?
    
    init(configuration: MapViewConfigurationViewModel? = nil,
         pinResponseModel: PinResponseModel.Type = MapboxResponseEmptyModel.self,
         routePinResponseModel: RoutePinResponseModel.Type = MapboxResponseEmptyModel.self,
         @ViewBuilder pinContent: @escaping (Any?) -> PinContent = { _ in Color.red },
         @ViewBuilder pinCluster: @escaping (CKCluster) -> PinCluster = { _ in Color.green },
         @ViewBuilder viewForRoutePin: @escaping (Any?) -> RoutePin = { _ in Color.blue }) {
        self.configuration = configuration
        self.pinContent = pinContent
        self.pinCluster = pinCluster
        self.viewForRoutePin = viewForRoutePin
    }
    
    
    
    func makeUIView(context: Context) -> MGLMapView {
        
        let mapView = CustomMGLMapView(frame: .zero,
                                       styleURL: (layerURL ?? "https://map.jertam.com/styles/jertam/style.json?key=jertam").url)
     
        let algorithm = CKNonHierarchicalDistanceBasedAlgorithm()
        algorithm.cellSize = 500
        
        mapView.clusterManager.algorithm = algorithm
        mapView.clusterManager.marginFactor = 1
       
        let tapGestureRecognizer = UITapGestureRecognizer(target: context.coordinator,
                                                          action: #selector(Coordinator.handleMapTap(_:)))
        for recognizer in mapView.gestureRecognizers! where recognizer is UITapGestureRecognizer {
            tapGestureRecognizer.require(toFail: recognizer)
        }
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        context.coordinator.mapView = mapView
        didSetMap?(mapView)
        
        mapView.delegate = context.coordinator.mapboxProxy
        
        return mapView
    }
    
    func updateUIView(_ uiView: MGLMapView, context: Context) {
      
     
    }
  
    func makeCoordinator() -> MapboxUIViewRepresentable.Coordinator {
        return Coordinator(parent: self, configuration: configuration)
    }
}


class CustomMGLPolyline: MGLPolyline{
    var color:UIColor?
}
