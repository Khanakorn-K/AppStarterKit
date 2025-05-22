//
//  MapboxUIViewRepresentable+Buildable.swift
//  AppStarterKit
//
//  Created by MK-Mini on 27/4/2568 BE.
//

import Mapbox
import SwiftUI
import ClusterKit

extension MapboxUIViewRepresentable: Buildable {
    func didTapGround(_ handler: @escaping ((CLLocationCoordinate2D)->())) -> Self{
        mutating(keyPath: \.didTapGround, value: handler)
    }

    func didClearTapGround(_ handler: @escaping (()->())) -> Self{
        mutating(keyPath: \.didClearTapGround, value: handler)
    }

    func didSelectPin(_ handler: @escaping ((UserInfoMGLPointAnnotationView)->())) -> Self{
        mutating(keyPath: \.didSelectPin, value: handler)
    }

    func didFinishLoadMap(_ perform: ((MGLMapView)->())?) -> Self {
        mutating(keyPath: \.didFinishLoadMap, value: perform)
    }
    
    func didTapExpand(icon: UIImage? = nil, _ perform: (()->())? = nil) -> Self {
        mutating(keyPath: \.didTapExpand, value: perform)
            .mutating(keyPath: \.attributionButtonImage, value: icon)
    }
    
    func userLocationVisibleChange(_ perform: ((Bool)->())? = nil) -> Self {
        mutating(keyPath: \.userLocationVisibleChange, value: perform)
    }
    
    func onPinUpdate(_ perform: (()->())?) -> Self {
        mutating(keyPath: \.onPinUpdate, value: perform)
    }
    
    func didSetMap(_ perform: ((MGLMapView)->())?) -> Self {
        mutating(keyPath: \.didSetMap, value: perform)
    }

    func coordinateFocus(_ value: CLLocationCoordinate2D) -> Self {
        mutating(keyPath: \.coordinateFocus, value: value)
    }
    
    func firstZoom(_ value: CGFloat) -> Self {
        mutating(keyPath: \.firstZoom, value: value)
    }
    
    func showRoute(_ value: Bool) -> Self {
        mutating(keyPath: \.isShowRoute, value: value)
    }
    
    func showPin(_ value: Bool) -> Self {
        mutating(keyPath: \.isShowPin, value: value)
    }
    
    func showPoint(_ value: Bool) -> Self {
        mutating(keyPath: \.isShowPoint, value: value)
    }
    
    func showButtonExpandMap(_ value: Bool) -> Self {
        mutating(keyPath: \.isShowButtonExpandMap, value: value)
    }
    
    func mapLayerURL(_ value: String) -> Self {
        mutating(keyPath: \.layerURL, value: value)
    }
    
    func mapURLForPin(_ value: ((_ bbox: String) -> (String))?) -> Self {
        mutating(keyPath: \.urlForPin, value: value)
    }
    
    func pinSize(_ value: CGSize) -> Self {
        mutating(keyPath: \.pinSize, value: value)
    }
    
    func clusterSize(_ value: CGSize) -> Self {
        mutating(keyPath: \.clusterSize, value: value)
    }
    
    func annotationFor(_ value: ((PinResponseModel?) -> ([MGLPointAnnotation]))?) -> Self {
        mutating(keyPath: \.annotationFor, value: value)
    }
    
    func didSelectCluster(_ value: (([UserInfoMGLPointAnnotationView])->())?) -> Self {
        mutating(keyPath: \.didSelectCluster, value: value)
    }
    
    func urlForRoutePin(_ value:  ((_ bbox: String) -> (String))?) -> Self {
        mutating(keyPath: \.urlForRoutePin, value: value)
    }
    
    func urlForRouteLine(_ value:  ((_ bbox: String) -> (String))?) -> Self {
        mutating(keyPath: \.urlForRouteLine, value: value)
    }
    
    func annotationForRoutePin(_ value: ((RoutePinResponseModel?) -> ([MGLPointAnnotation]))?) -> Self {
        mutating(keyPath: \.annotationForRoutePin, value: value)
    }
    
    func routePinSize(_ value: CGSize) -> Self {
        mutating(keyPath: \.routePinSize, value: value)
    }
}
