//
//  NewsFeedPlaceRequestModel.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//
import Foundation

struct NewsFeedPlaceRequestModel : Codable{
    let nearLng: String
    let pageNumber : Int
    let nearLat:String
    let rowPerPage :Int
    init(nearLng: String, pageNumber: Int, nearLat: String, rowPerPage: Int = 10)  {
        self.nearLng = nearLng
        self.pageNumber = pageNumber
        self.nearLat = nearLat
        self.rowPerPage = rowPerPage
    }
}
