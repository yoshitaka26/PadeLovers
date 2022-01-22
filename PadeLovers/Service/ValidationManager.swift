//
//  ValidationManager.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/23.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation

enum ValidationResult {
    case valid
    case invalid
}

protocol ValidationErrorProtocol: LocalizedError { }

protocol Validator {
    func validate(_ value: String) -> ValidationResult
}

protocol CompositeValidator: Validator {
    var validators: [Validator] { get }
    func validate(_ value: String) -> ValidationResult
}

extension CompositeValidator {
    func validate(_ value: String) -> [ValidationResult] {
        return validators.map { $0.validate(value) }
    }
    func validate(_ value: String) -> ValidationResult {
        let results: [ValidationResult] = validate(value)
        
        let errors = results.filter { result -> Bool in
            switch result {
            case .valid:
                return false
            case .invalid:
                return true
            }
        }
        return errors.first ?? .valid
    }
}

struct EmptyValidator: Validator {
    func validate(_ value: String) -> ValidationResult {
        if value.isEmpty == true {
            return .invalid
        } else {
            return .valid
        }
    }
}

struct LengthValidator: Validator {
    let min: Int
    let max: Int
    
    func validate(_ value: String) -> ValidationResult {
        if value.count >= min && value.count <= max {
            return .valid
        } else {
            return .invalid
        }
    }
}

struct CharacterValidatior: Validator {
    
    func validate(_ value: String) -> ValidationResult {
        guard let name: NSString = (value as NSString?) else { return .invalid }
        // CP932でNSDataとの相互変換を行い
        guard let convertedNameData = name.data(using: String.Encoding.shiftJIS.rawValue), let convertedName = NSString(data: convertedNameData, encoding: String.Encoding.shiftJIS.rawValue) else {
            return .invalid
        }
        // 同じ文字になっている（CP932でサポートされている文字のみで構成）ならOK
        guard name.isEqual(to: convertedName as String) else { return .invalid }
        return .valid
    }
}

final class ValidationManager: CompositeValidator {
    static let shared = ValidationManager()
    
    var validators: [Validator] = [
        EmptyValidator(),
        LengthValidator(min: 1, max: 7),
        CharacterValidatior()
    ]
}
