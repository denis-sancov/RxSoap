//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation

public protocol ErrorInterceptor: class {
    func canIntercept(code: Int) -> Bool
    func intercept<A: Action>(error: SoapError<A>)
}
