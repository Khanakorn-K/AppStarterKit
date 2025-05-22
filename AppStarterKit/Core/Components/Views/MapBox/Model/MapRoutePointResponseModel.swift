//
//  MapRoutePointResponseModel.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 8/3/2567 BE.
//

import Foundation

struct MapRoutePointResponseModel: Codable {
    let type: String
    let features: [Feature]
    let totalFeatures, numberMatched, numberReturned: Int
    let timeStamp: String
//    let crs: CRS
    
    
    // MARK: - CRS
    struct CRS: Codable {
        let type: String
        let properties: CRSProperties
    }

    // MARK: - CRSProperties
    struct CRSProperties: Codable {
        let name: String
    }

    // MARK: - Feature
    struct Feature: Codable {
        let type, id: String
        let geometry: Geometry
        let geometryName: String
        let properties: FeatureProperties

        enum CodingKeys: String, CodingKey {
            case type, id, geometry
            case geometryName = "geometry_name"
            case properties
        }
    }

    // MARK: - Geometry
    struct Geometry: Codable {
        let type: String
        let coordinates: [Double]
    }

    // MARK: - FeatureProperties
    struct FeatureProperties: Codable {
        let osmID, name, barrier, highway: String
        let ref, address, isIn, place: String
        let manMade, otherTags: String

        enum CodingKeys: String, CodingKey {
            case osmID = "osm_id"
            case name, barrier, highway, ref, address
            case isIn = "is_in"
            case place
            case manMade = "man_made"
            case otherTags = "other_tags"
        }
    }
}
