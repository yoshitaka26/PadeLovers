//
//  RequestContentType.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/25.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

public enum RequestContentType: String {
    case json = "application/json"
    case xml = "application/xml"
    case formUrlencoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
}
