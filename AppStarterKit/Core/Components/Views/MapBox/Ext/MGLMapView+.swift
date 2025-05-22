//
//  MGLMapView+.swift
//  JERTAM
//
//  Created by Chanchana on 16/7/2567 BE.
//

import Foundation
import Mapbox

extension MGLMapView {
    var bboxString: String {
        // This method is called whenever the map's viewport changes.
        let visibleRegion = visibleCoordinateBounds
        //              let centerCoordinate = mapView.centerCoordinate
        
        // Extract the coordinates of the southwest and northeast corners
        let southwestCoordinate = visibleRegion.sw
        let northeastCoordinate = visibleRegion.ne
        
        // Convert the coordinates to comma-separated strings
        let southwestString = "\(southwestCoordinate.longitude),\(southwestCoordinate.latitude)"
        let northeastString = "\(northeastCoordinate.longitude),\(northeastCoordinate.latitude)"
        
        return "\(southwestString),\(northeastString)"
    }
    
    func clearMinZoom(zoom: Double = 0) {
        minimumZoomLevel = zoom
    }
    
    func fitToBound(coordninates: [CLLocationCoordinate2D], padding: CGFloat = 100) {
        clearMinZoom()
        self.setVisibleCoordinates(coordninates,
                                   count: UInt(coordninates.count),
                                   edgePadding: .init(horizontal: padding, vertical: padding),
                                   animated: true)
    }
}
