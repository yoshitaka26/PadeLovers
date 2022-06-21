//
//  WetherResponse.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/26.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let coord: CoordData
    let wind: WindData
}

struct CoordData: Decodable {
    let lon: Double
    let lat: Double
}

struct WindData: Decodable {
    let speed: Double
    let deg: Int
}
