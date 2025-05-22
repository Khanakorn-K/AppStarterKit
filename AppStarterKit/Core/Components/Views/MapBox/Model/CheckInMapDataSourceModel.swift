//
//  CheckInMapDataSource.swift
//  AppStarterKit
//
//  Created by Chanchana Koedtho on 27/9/2566 BE.
//

import Foundation
import CoreLocation
import SwifterSwift

struct CheckInMapDataSourceModel: AnnotationDataSourceModel{
    
    let stampId: Int
    let image: URL?
    let title: String
    let id: Int
    let coord: CLLocationCoordinate2D
    let placeId: Int
    let tragetCollectRangeInMeter: Int
    let stampImageURL: URL?
    let relateGuidebookId: Int
    let quests: MapQuestsResponseModel?
    let cateImageURL: URL?
    let gistType: GistType
    let guidebookId: Int
    
    init(coord: CLLocationCoordinate2D,
         tragetCollectRangeInMeter: Int,
         stampId: Int,
         placeId: Int,
         relateGuidebookId: Int,
         gistType: GistType) {
        self.image = nil
        self.title = ""
        self.id = 0
        self.coord = coord
        self.placeId = placeId
        self.stampId = stampId
        self.relateGuidebookId = relateGuidebookId
        
//#if DEBUG
//self.tragetCollectRangeInMeter = 0
//#else
        //fix value 
self.tragetCollectRangeInMeter = tragetCollectRangeInMeter
//#endif
        self.stampImageURL = nil
        self.quests = nil
        self.cateImageURL = nil
        self.gistType = gistType
        self.guidebookId = 0
    }
    
    init?(featureProperties: StampMapResult.FeatureProperties, index: Int) {
        let processorDownsize = "x-image-process=style/stamm2pin-sqr-300px"
        let pinImage = "https://jtinfoplc.obs.ap-southeast-2.myhuaweicloud.com/stamm/" + (featureProperties.pin?.removingQuery()?.appending("?\(processorDownsize)") ?? "")
        let cateImage = "https://jtinfoplc.obs.ap-southeast-2.myhuaweicloud.com/stamm/\(featureProperties.placeType!).png?x-image-process=style/stamm2pin-sqr-70px"
        let isShowCate = featureProperties.pin?.removingQuery()?.lastPathComponent.deletingPathExtension != featureProperties.placeType
        
        coord = .init(latitude: featureProperties.lat ?? 0, longitude: featureProperties.lng ?? 0)
        image = pinImage.url
        title = featureProperties.placeName ?? ""
        id = index
        placeId = featureProperties.placeID ?? 0
        tragetCollectRangeInMeter = featureProperties.getStammRadiusMeter ?? 0
        stampId = featureProperties.stammID ?? 0
        stampImageURL = pinImage.url//?.replacingOccurrences(of: ".jpg", with: ".png").url
        relateGuidebookId = featureProperties.relateGuidebookID
        quests = try? featureProperties.additionalInfo?.decoded(as: MapQuestsResponseModel.self)
        self.cateImageURL = featureProperties.placeType?.count ?? 0 > 0 && quests == nil ? (isShowCate ? cateImage.url:nil) : nil
        self.gistType = isShowCate ? featureProperties.gistType ?? .unknown : .guidebook
        self.guidebookId = featureProperties.guidebookID ?? 0
    }
}

extension CheckInMapDataSourceModel: Equatable{
    static func == (lhs: CheckInMapDataSourceModel, rhs: CheckInMapDataSourceModel) -> Bool {
        lhs.id == rhs.id
    }
}


extension String {
    func removingQuery() -> String? {
        guard var urlComponents = URLComponents(string: self) else { return nil }
        urlComponents.query = nil
        return urlComponents.url?.absoluteString
    }
}
