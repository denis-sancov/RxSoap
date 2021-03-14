//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation

public enum SoapError<A: Action> {
    case service(action: A, model: A.ResultType?, code: Int, msg: String)
    case data(action: A, msg: String)

    var code: Int {
        switch self {
        case .service(_, _, let code, _):
            return code
        default:
            return -1
        }
    }
}

extension SoapError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .service( _, _, _, let msg):
            return msg
        case .data(_ , let msg):
            return msg
        }
    }
}
