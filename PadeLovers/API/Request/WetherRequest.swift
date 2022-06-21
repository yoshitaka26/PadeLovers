//
//  WetherRequest.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/26.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

struct WetherRequest: RequestProtocol {
    typealias Response = WeatherResponse
    
    var appid: String
    var lon: String
    var lat: String
    
    var method: HTTPMethod {
        return .get
    }
    
    var baseURL: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/")! // swiftlint:disable:this force_unwrapping
    }
    
    var prefixPath: String? {
        return nil
    }
    
    var path: String {
        return "weather"
    }
    
    var headerFields: [String: String]? {
        return nil
    }
    
    var queryItems: [String: String?]? {
        return [
            "appid": appid,
            "lon": lon,
            "lat": lat
        ]
    }
    
    var body: RequestBody? {
        return nil
    }
    
    var acceptContentType: RequestContentType? {
        return .formUrlencoded
    }
    
    func processRequest(_ request: URLRequest) throws -> URLRequest {
        return request
    }

    func processResponse(data: Data, response: HTTPURLResponse) throws -> Data {
        return data
    }
}
