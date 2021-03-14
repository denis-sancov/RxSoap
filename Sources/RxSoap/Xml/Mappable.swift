//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation

public enum MappableError: Error {
    case conversionFailed(type: String, value: String)
}

public protocol Mappable {
    static func map(value: String) throws -> Self
}

extension Bool: Mappable {
    public static func map(value: String) throws -> Bool {
        guard let result = Bool(value) else {
            throw MappableError.conversionFailed(type: "bool", value: value)
        }
        return result
    }
}

extension Int8: Mappable {
    public static func map(value: String) throws -> Int8 {
        guard let result = Int8(value) else {
            throw MappableError.conversionFailed(type: "Int8", value: value)
        }
        return result
    }
}

extension Int16: Mappable {
    public static func map(value: String) throws -> Int16 {
        guard let result = Int16(value) else {
            throw MappableError.conversionFailed(type: "Int16", value: value)
        }
        return result
    }
}

extension Int: Mappable {
    public static func map(value: String) throws -> Int {
        guard let result = Int(value) else {
            throw MappableError.conversionFailed(type: "Int", value: value)
        }
        return result
    }
}

extension Int64: Mappable {
    public static func map(value: String) throws -> Int64 {
        guard let result = Int64(value) else {
            throw MappableError.conversionFailed(type: "Int64", value: value)
        }
        return result
    }
}

extension Double: Mappable {
    public static func map(value: String) throws -> Double {
        guard let result = Double(value) else {
            throw MappableError.conversionFailed(type: "Double", value: value)
        }
        return result
    }
}

extension Decimal: Mappable {
    public static func map(value: String) throws -> Decimal {
        guard let result = Decimal(string: value) else {
            throw MappableError.conversionFailed(type: "Decimal", value: value)
        }
        return result
    }
}

extension String: Mappable {
    public static func map(value: String) throws -> String {
        return value
    }
}

extension URL: Mappable {
    public static func map(value: String) throws -> URL {
        guard let result = URL(string: value) else {
            throw MappableError.conversionFailed(type: "URL", value: value)
        }
        return result
    }
}
