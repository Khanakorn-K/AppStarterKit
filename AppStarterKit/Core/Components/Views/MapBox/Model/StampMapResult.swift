//
//  StampMapResult.swift
//  FIrstFullSwiftUI
//
//  Created by Chanchana Koedtho on 28/9/2566 BE.
//

import Foundation


// MARK: - StampMapResult
struct StampMapResult: Codable {
    let type: String
    let features: [Feature]
    let totalFeatures, numberMatched, numberReturned: Int
    let timeStamp: String
    let crs: CRS?
    
    
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
        let placeID: Int?
        let placeName, placeDetail, placeCover, placeType: String?
        let address: String?
        let lat, lng: Double?
        let pin: String?
        let stammID: Int?
        let stammImage: String?
        let guidebookID: Int?
        let getStammRadiusMeter: Int?
//        let communityID: JSONNull?
        let relateGuidebookID: Int
        let additionalInfo: String?
        let gistType: GistType?

        enum CodingKeys: String, CodingKey {
            case placeID = "PlaceID"
            case placeName = "PlaceName"
            case placeDetail = "PlaceDetail"
            case placeCover = "PlaceCover"
            case placeType = "PlaceType"
            case address = "Address"
            case lat = "Lat"
            case lng = "Lng"
            case pin = "Pin"
            case stammID = "StammID"
            case stammImage = "StammImage"
            case guidebookID = "GuidebookID"
            case getStammRadiusMeter = "GetStammRadiusMeter"
//            case communityID = "CommunityID"
            case relateGuidebookID = "RelateGuidebookID"
            case additionalInfo = "AdditionalInfo"
            case gistType = "GistType"
        }
    }

}
