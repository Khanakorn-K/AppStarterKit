//
//  MapRouteResponseModel.swift
//  JERTAM
//
//  Created by Chanchana Koedtho on 8/3/2567 BE.
//

import Foundation

struct MapRouteResponseModel: Codable {
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
        let coordinates: [[[Double]]]
    }

    // MARK: - FeatureProperties
    struct FeatureProperties: Codable {
        let osmID, name, highway, waterway: String
        let aerialway, barrier, manMade: String
        let zOrder: Int
        let otherTags: String

        enum CodingKeys: String, CodingKey {
            case osmID = "osm_id"
            case name, highway, waterway, aerialway, barrier
            case manMade = "man_made"
            case zOrder = "z_order"
            case otherTags = "other_tags"
        }
    }
}
