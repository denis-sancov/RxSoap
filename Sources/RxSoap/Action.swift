//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import AEXML
import Foundation
import FCB_utils

public protocol Action {
    associatedtype ResultType

    var name: String { get }

    var params: KeyValuePairs<String, Any> { get }

    func map(node: Node) throws -> ResultType?
}

public extension Action {
    var params: KeyValuePairs<String, Any> {
        return [:]
    }
}

public extension Action where ResultType: Model {
    func map(node: Node) throws -> ResultType? {
        return try ResultType(node: node)
    }
}

fileprivate let roundBehaviour = NSDecimalNumberHandler(
    roundingMode: .up,
    scale: 10,
    raiseOnExactness: false,
    raiseOnOverflow: false,
    raiseOnUnderflow: false,
    raiseOnDivideByZero: false
)

extension URLRequest {
    init<T: Action>(host: URL, action: T) {
        self.init(url: host)

        let document = AEXMLDocument()

        let attributes = [
            "xmlns:soapenv": "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tem": "http://tempuri.org/"
        ]
        let envelopeEl = document.addChild(
            name: "soapenv:Envelope", attributes: attributes
        )
        envelopeEl.addChild(name: "soapenv:Header")

        let bodyEl = envelopeEl.addChild(name: "soapenv:Body")

        let name = action.name
        let actionElement = bodyEl.addChild(name: "tem:\(name)")

        action.params.forEach { pair in
            let property = pair.key
            let data: String

            switch pair.value {
            case let value as Decimal:
                data = NSDecimalNumber(decimal: value)
                    .rounding(accordingToBehavior: roundBehaviour)
                    .stringValue

            case let value as String:
                data = value

            case let value as LosslessStringConvertible:
                data = value.description

            default:
                return
            }

            actionElement.addChild(
                name: "tem:\(property)",
                value: data.trimWhitespaces
            )
        }

        let envelope = document.xmlCompact

        allHTTPHeaderFields = [
            "Content-Type": "text/xml; charset=utf-8",
            "Content-Length": String(envelope.count),
            "SOAPAction": "http://tempuri.org/IService/\(name)"
        ]

        httpMethod = "POST"
        httpBody = envelope.data(using: .utf8)
    }
}
