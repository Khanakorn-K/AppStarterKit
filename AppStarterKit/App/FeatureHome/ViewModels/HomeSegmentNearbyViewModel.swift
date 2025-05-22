//
//  HomeSegmentNearbyViewModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//

import SwiftUI
import SwiftLocation
import CoreLocation

@MainActor
class HomeSegmentNearbyViewModel:ObservableObject{
    private let feedService = FeedService()
    private let locationManager = Location()
    private var pageNumber = 1
    private var isEndPage = false
    private var rowPerPage = 10
    private var coord : CLLocationCoordinate2D?
    @Published private(set) var nearbyList:[HomeSegmentNearbyModel] = []
    //MARK: public
    public func handleOnAppear() async throws {
         await handleGetLocation()
        nearbyList = try await loadNearbyPlace()
    }
    public func handleLoadNextPage(lastItem:HomeSegmentNearbyModel) async throws {
        
        guard !isEndPage else {return}
        guard  lastItem.id == nearbyList.last?.id else { return  }
        pageNumber += 1
        let response = try await loadNearbyPlace()
        if response.count < rowPerPage {
            isEndPage = true
        }
        nearbyList += response
    }
    public func handleGetLocation() async  {
        let crood  = await getLocation()
        self.coord = crood
    }
    public func handleRefresh() async throws{
        pageNumber = 1
        isEndPage = false
        coord = nil
        nearbyList = []
        try await handleOnAppear()
    }
    //MARK: private
    private func loadNearbyPlace()async throws ->  [HomeSegmentNearbyModel]{
        let response = try await feedService.fetchPlaceList(.init(
            nearLng: "\(coord?.longitude ?? 0 )", pageNumber: pageNumber, nearLat: "\(coord?.longitude ?? 0)"
        ))
        guard let result = response.result else { return  [] }
        return result.compactMap{$0}.map{.init($0)}
    }
    private func getLocation() async  -> CLLocationCoordinate2D? {
        do{
            let permision = try await locationManager.requestPermission(.whenInUse)
            guard  permision == .authorizedWhenInUse else{return nil}
            let location = try await locationManager.requestLocation().location?.coordinate
            return location
        }catch{
            return nil
        }
    }
}
