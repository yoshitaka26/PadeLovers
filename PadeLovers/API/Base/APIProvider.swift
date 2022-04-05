//
//  APIProvider.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/25.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift

public final class APIProvider: NSObject {
    public static let shared = APIProvider()

    private let session: URLSession
    private let sessionHandler = URLSessionDelegateHandler()

    public init(sessionConfig: URLSessionConfiguration = .default, delegateQueue: OperationQueue = .main) {
        sessionConfig.timeoutIntervalForRequest = TimeInterval(30)
        session = URLSession(configuration: sessionConfig, delegate: sessionHandler, delegateQueue: delegateQueue)
    }

    func rxSend<T: RequestProtocol>(request: T) -> Observable<Result<T.Response, Error>> {
        return responseObservable(request: request).flatMap { result -> Observable<Result<T.Response, Error>> in
            switch result {
            case let .success(value):
                return Observable.just(Result.success(value))
            case let .failure(error):
                return Observable.just(Result.failure(error))
            }
        }
    }

    func responseObservable<T: RequestProtocol>(request: T) -> Observable<Result<T.Response, Error>> {
        return Observable<Result<T.Response, Error>>.create({ observer -> Disposable in
            self.send(request: request, completionHandler: { result in
                observer.onNext(result)
            })
            
            return Disposables.create()
        })
    }

    /// Send HTTP request.
    ///
    /// - Parameters:
    ///   - request: HTTP request
    ///   - completionHandler: Return the response of network request, whether success or failure.
    public func send<Request: RequestProtocol>(request: Request, completionHandler: @escaping (Result<Request.Response, Error>) -> Void) {
        let urlRequest: URLRequest
        do {
            urlRequest = try request.processRequest(request.build())
        } catch let error {
            completionHandler(.failure(ResponseError(error: error, message: "Request Build Error")))
            return
        }
        debugDescription(urlRequest)
        let task = session.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
            if let error = error {
                if let urlError = error as? URLError {
                    completionHandler(.failure(ResponseError(urlError: urlError, message: urlError.localizedDescription)))
                }

                completionHandler(.failure(error))
            }

            if let response = urlResponse as? HTTPURLResponse {
                // レスポンスコードが400以上ならエラーオブジェクトを生成
                if response.statusCode > 400 {
                    completionHandler(.failure(ResponseError(errorCode: response.statusCode)))
                    self?.debugResponse(response, data: data)
                }
            }

            if let data = data, let response = urlResponse as? HTTPURLResponse {
                self?.debugResponse(response, data: data)
                do {
                    let data = try request.processResponse(data: data, response: response)
                    let response = try request.decodeResponse(from: data, response: response)
                    completionHandler(.success(response))
                } catch let error {
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
}

extension APIProvider: URLSessionDataDelegate {
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("bytesSent: \(bytesSent)   totalSent: \(totalBytesSent)  totalExpectedToWrite:\(totalBytesExpectedToSend)} \n  ")
    }
}

// MARK: - Print log

extension APIProvider {
    /// Print request's information.
    ///
    /// - Parameter url: URLRequest
    func debugDescription(_ request: URLRequest) {
        var output: [String] = []
        output.append("=========== HTTP REQUEST ===========")
        output.append("[Request]: \(String(describing: request.httpMethod)) \(String(describing: request.url))")
        output.append("[Header]: \(String(describing: request.allHTTPHeaderFields))")
        if let body = request.httpBody {
            output.append("[Body]: \(String(data: body, encoding: String.Encoding.utf8) ?? "")")
        }

        let outputString = output.joined(separator: "\n")
        print(outputString)
    }

    func debugResponse(_ response: HTTPURLResponse, data: Data?) {
        var output: [String] = []

        output.append("=========== HTTP RESPONSE ===========")
        output.append("[Response]: \(String(describing: response.url))") // original url request
        output.append("[Status Code]: \(response.statusCode)")
        output.append("[Header]: \(response.allHeaderFields)")

        var body: String = ""
        do {
            if let d = data {
                let json = try JSONSerialization.jsonObject(with: d)
                let prettyData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
                body = String(data: prettyData, encoding: .utf8) ?? "nil"
            }

        } catch {
            print("\(error)")
            body = "nil"
        }
        output.append("[Body]: \(body)")
        let outputString = output.joined(separator: "\n")
        print(outputString)
    }
}
