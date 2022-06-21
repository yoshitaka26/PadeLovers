//
//  ResponseError.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/03/25.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

public struct ResponseError: Error {
    var errors: ErrorDetail?
}

struct ErrorDetail {
    var code: String?
    var debugMessage: String?
    var message: String?

    init(code: String, debug: String, message: String) {
        self.code = code
        debugMessage = debug
        self.message = message
    }
}

extension ResponseError {
    init(urlError: URLError, message: String) {
        errors = ErrorDetail(code: String(urlError.code.rawValue), debug: urlError.localizedDescription, message: message)
    }

    init(error: Error, message: String) {
        errors = ErrorDetail(code: "-999", debug: error.localizedDescription, message: message)
    }

    init(errorCode: Int, message: String = "") {
        errors = ErrorDetail(code: "\(errorCode)", debug: "Http Error", message: message)
    }
}
