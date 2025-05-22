//
//  MapViewConfigurationViewModel.swift
//  JERTAM
//
//  Created by Chanchana on 16/7/2567 BE.
//

import Foundation
import CoreLocation
import Mapbox
import Combine
import MapboxDirections

@MainActor
class MapViewConfigurationViewModel: ObservableObject {
  
    var mapView: (()->(MGLMapView?))?
    var isViewDisappear = false
    
    var forceClearTapGroundPin:(()->())?
    
    var forceRefreshHandler:(()->())?
    
    var didRequestDirection:(([Waypoint])->())?
    
    var cancellable: Set<AnyCancellable> = .init()
    
    init() {
        
    }
    
    func clearTapGrouldPin(){
        forceClearTapGroundPin?()
    }
    
    func forceRefresh(){
        forceRefreshHandler?()
    }
    
    func requestDirection(waypoints:[Waypoint]){
        didRequestDirection?(waypoints)
    }
    
    func updateViewDisappear(with value: Bool, from: String = "") {
        print("update isViewDisappear = \(value) from \(from)")
        isViewDisappear = value
    }
}
