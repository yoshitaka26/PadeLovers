//
//  APIDataManager.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/26.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift

//protocol APIDataManagerProtocol {
//    static func fetchWetherData(lon: Double, lat: Double) -> Observable<Result<WeatherResponse, Error>>
//}
//
//class APIDataManager: APIDataManagerProtocol {
//    static func fetchWetherData(lon: Double, lat: Double) -> Observable<Result<WeatherResponse, Error>> {
//        let request = WetherRequest(appid: openWetherMapAPIKey, lon: lon.description, lat: lat.description)
//        return APIProvider.shared.rxSend(request: request)
//    }
//}
