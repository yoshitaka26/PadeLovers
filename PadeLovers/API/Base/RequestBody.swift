//
//  RequestBody.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/25.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

// swiftlint:disable missing_docs
public protocol RequestBody {
    var contentType: String { get }
    func toData() throws -> Data
}
// swiftlint:enable missing_docs

public struct FormUrlencodeRequestBody: RequestBody {
    private let json: [String: Any]

    public init(json: [String: Any]) {
        self.json = json
    }

    public var contentType: String {
        return RequestContentType.formUrlencoded.rawValue
    }

    public func toData() throws -> Data {
        let string = self.string(from: json)

        return string.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
    }

    public func string(from dictionary: [String: Any]) -> String {
        let pairs = dictionary.map { key, value -> String in
            if value is NSNull {
                return "\(key)"
            }
            if let array = value as? [String] {
                let arrayPairs = array.map {
                    return "\(key)=\($0.urlEncoded)"
                }
                return arrayPairs.joined(separator: "&")
            } else {
                let valueAsString = (value as? String) ?? "\(value)"
                return "\(key)=\(valueAsString.urlEncoded)"
            }
        }
        return pairs.joined(separator: "&")
    }
}
