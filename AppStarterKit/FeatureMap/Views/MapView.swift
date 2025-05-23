//
//  MapView.swift
//  AppStarterKit
//
//  Created by MacMini_M4-01 on 23/5/2568 BE.
//
import SwiftUI
import Kingfisher
import SwifterSwift
import ClusterKit
import Mapbox
struct MapView:View {
    private let mapLayerURL = "https://map.jertam.com/styles/jertam/style.json?key=jertam"
    @Weak private var mapView:MGLMapView?
    var body: some View {
        ZStack(){
            MapboxUIViewRepresentable(
                pinResponseModel: StampMapResult.self,
                routePinResponseModel: MapRoutePointResponseModel.self,
                pinContent: pinContentView,
                pinCluster: pinClusterView,
                viewForRoutePin: viewForRoutePin
            )
            .annotationFor(pinAnnotation)
            .mapLayerURL(mapLayerURL)
            .mapURLForPin(mapURLForPin)
            .didSelectPin(didSelectPin)
            .didSelectCluster(didSelectCluster)
            .coordinateFocus(.init(latitude: 12.24922286500599, longitude: 102.50195812636997))
            .urlForRouteLine(urlForRouteLine)
            .urlForRoutePin(urlForToutePin)
            .annotationForRoutePin(annotationForRoutePin)
            .didSetMap{
                map in self.mapView = map
            }
        }
        .withDefaultNavigaitionView(title: "แผนที่" , isShowBackButton: false)
        .overlay(alignment:.bottomTrailing){
            Button(action: {
                mapView?.setCenter(.init(latitude: 13.7584984, longitude: 100.5660958),animated: true
                )
            }, label: {
                Circle()
                    .fill(.red)
            })
            .frame(60)
            .padding([.bottom,.trailing])
        }
    }
    @ViewBuilder
    private func pinContentView(info:Any) -> some View {
        let pinInfo = info  as? StampMapResult.FeatureProperties
        let processorDownSize = "?x-image-process=style/stamm2pin-sqr-300px"
        let pinImageURL = pinInfo?.pin?.removingQuery()?.appending(processorDownSize)
        ZStack{
            Image(.icBasePin)
                .resizable()
                .scaledToFill()
            KFImage(pinImageURL?.url)
                .resizable()
                .scaledToFit()
                .frame(50)
                .clipShape(Circle())
                .offset(y: -5)
            
        }
    }
    
    private func pinAnnotation(_ pinResponse:StampMapResult?)->[UserInfoMGLPointAnnotationView]{
        pinResponse?.features
            .compactMap{
                pin in
                let annotaion = UserInfoMGLPointAnnotationView()
                let lat = pin.properties.lat ?? 0
                let lng = pin.properties.lng ?? 0
                annotaion.coordinate = .init(latitude: lat, longitude: lng)
                annotaion.title = pin.properties.placeName
                annotaion.userInfo = pin.properties
                return annotaion
            } ?? []
    }
    
    @ViewBuilder
    private func pinClusterView(info:CKCluster) -> some View {
        ZStack{
            Circle()
                .fill(.white)
            Text("\(info.count)")
                .bodyFont()
                .colorMainApp()
        }
    }
    
    private func mapURLForPin(_ bbox:String)->String{
        let bboxQuery = "cql_filter=BBOX(geom ,\(bbox))"
        let url = "https://layer.jertam.com/geoserver/jertammap/ows?service=WFS&version=1.0.0&request=GetFeature&typename=jertammap:MapBaseRepository&outputFormat=application/json&srsname=EPSG:4326&cql_filter=BBOX(geom ,\(bbox))"
        return url
    }
    
    private func didSelectPin(info:UserInfoMGLPointAnnotationView){
        print(info)
    }
    
    private func didSelectCluster(info:[UserInfoMGLPointAnnotationView]){
        print("clustter count : \(info.count)")
    }
    
    private func urlForRouteLine(_ bbox:String)->String{
        let url = "https://layer.jertam.com/geoserver/jertammap/ows?service=WFS&version=1.0.0&request=GetFeature&typename=jertammap:walkruntrailroute&outputFormat=application/json&srsname=EPSG:4326&bbox=\(bbox)"
        return url
    }
    private func urlForToutePin(_ bbox:String)->String{
        let url:String = "https://layer.jertam.com/geoserver/jertammap/ows?service=WFS&version=1.0.0&request=GetFeature&typename=jertammap:walkruntrailpoint&outputFormat=application/json&srsname=EPSG:4326&bbox=\(bbox)"
        return url
    }
    private func annotationForRoutePin(_ routePinResponse:MapRoutePointResponseModel?)->[UserInfoMGLPointAnnotationView]{
        routePinResponse?.features
            .compactMap{pin in
                let annotaion = UserInfoMGLPointAnnotationView()
                let lat = pin.geometry.coordinates[1]
                let lng = pin.geometry.coordinates[0]
                annotaion.coordinate = .init(latitude: lat, longitude: lng)
                annotaion.title = pin.properties.name
                annotaion.userInfo = pin.properties
                annotaion.isRoutePin = true
                return annotaion
            } ?? []
    }
    @ViewBuilder
    private func viewForRoutePin(_ info:Any?)->some View{
        let info = info as? MapRoutePointResponseModel.FeatureProperties
        ZStack{
            Group{
                if info?.name == "Parking"{
                    Image(.icParking)
                        .resizable()
                }else{
                    Image(.icWater)
                        .resizable()
                }
            }
            .scaledToFit()
        }
    }
}

//struct CustomPinView: PinView {
//    var didShowSubMissionUpdate: ((@escaping (Bool) -> Void) -> Void)?
//    var disCateImageUpdate: ((@escaping (URL?) -> Void) -> Void)?
//    var didPinImageUpdate: ((@escaping (URL?) -> Void) -> Void)?
//
//    @State var pinImageURL: URL?
//    @State var cateImageURL: URL?
//    @State var isShowSubMission: Bool? = true
//
//    var body: some View {
//        ZStack(alignment: .center) {
//            Image(.icBasePin)
//                .resizable()
//                .scaledToFit()
//
//            KFImage(pinImageURL)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 50, height: 50)
//                .clipShape(Circle())
//                .offset(y: -5)
//        }
//        .onAppear(perform: binding)
//    }
//
//    private func binding() {
//        didPinImageUpdate? { url in
//            pinImageURL = url
//        }
//    }
//}

#Preview {
    MapView()
}
