//
//  RequestProtocol.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/25.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

// swiftlint:disable missing_docs
public protocol RequestProtocol {
    associatedtype Response

    var method: HTTPMethod { get }

    var baseURL: URL { get }

    var prefixPath: String? { get }

    var path: String { get }

    var headerFields: [String: String]? { get }

    var queryItems: [String: String?]? { get }

    var body: RequestBody? { get }

    var acceptContentType: RequestContentType? { get }

    func processRequest(_ request: URLRequest) throws -> URLRequest

    func processResponse(data: Data, response: HTTPURLResponse) throws -> Data

    func decodeResponse(from data: Data, response: HTTPURLResponse) throws -> Response
}

extension RequestProtocol {
    public func build() throws -> URLRequest {
        guard var urlComps = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            fatalError("Request Protocol Build Error")
        }

        var path = self.path
        if let prefix = prefixPath {
            path = prefix + path
        }

        urlComps.path += path
        if let queryItems = queryItems {
            urlComps.queryItems = queryItems.map(URLQueryItem.init(name:value:))
        }

        guard let url = urlComps.url else {
            fatalError("Request Protocol Build Error")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headerFields

        if let body = body {
            request.addValue(body.contentType, forHTTPHeaderField: "Content-Type")
            request.httpBody = try body.toData()
        }

        if let accept = acceptContentType {
            if accept == .formData {
                request.addValue("*/*", forHTTPHeaderField: "Accept")
            } else {
                request.addValue(accept.rawValue, forHTTPHeaderField: "Accept")
            }
        }
        return request
    }

    public func decodeResponse(from data: Data, response: HTTPURLResponse) throws {
        return
    }

    /// Decode JSON response
    ///
    /// - Parameters:
    ///   - data: response data
    ///   - response: HTTPURLResponse
    /// - Returns: The response which implement the swift's decoble protocol.
    /// - Throws: JSON decobe error.
    public func decodeResponse<R>(from data: Data, response: HTTPURLResponse) throws -> R where R: Decodable, R == Response {
        var data = data
        if data.count == 0 {
            data = makeEmptyJson()
        }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(R.self, from: data)
    }

    private func makeEmptyJson() -> Data {
        let string = "{}"
        let data = string.data(using: .utf8)
        return data! // swiftlint:disable:this force_unwrapping
    }
}
// swiftlint:enable missing_docs
