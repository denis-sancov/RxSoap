//
//  File.swift
//  
//
//  Created by Denis Sancov on 3/14/21.
//

import Foundation
import RxSwift
import RxCocoa

public final class Service {
    public let endpoint: Endpoint
    public let session: URLSession!

    private var interceptors = [ErrorInterceptor]()

    public init(endpoint: Endpoint, session: URLSession) {
        self.endpoint = endpoint
        self.session = session
    }

    public func register(interceptor: ErrorInterceptor) {
        interceptors.append(interceptor)
    }

    public func unregister(interceptor: ErrorInterceptor) {
        interceptors.removeAll { $0 === interceptor }
    }

    public func call<A: Action>(_ action: A) -> Observable<Response<A>> {
        let request = URLRequest(host: endpoint.asURL, action: action)

        return session.rx
            .data(request: request)
            .flatMapLatest { [unowned self] data -> Observable<Response<A>> in
                let envelope = try Envelope(data: data)

                print("got envelope \(envelope)")

                var model: A.ResultType?

                if let node = envelope.data {
                    model = try? action.map(node: node)
                }

                guard envelope.code == 0 else {
                    let err = SoapError.service(
                        action: action,
                        model: model,
                        code: envelope.code,
                        msg: envelope.msg
                    )

                    let candidates = interceptors.filter { $0.canIntercept(code: envelope.code) }
                    
                    if candidates.count > 0 {
                        candidates.forEach { $0.intercept(error: err) }
                        return .never()
                    } else {
                        return .error(err)
                    }
                }

                guard let tmp = model else {
                    let err = SoapError.data(
                        action: action,
                        msg: "Soap.Error.InvalidData"
                    )

                    return .error(err)
                }

                let response = Response<A>(
                    code: envelope.code,
                    msg: envelope.msg,
                    model: tmp
                )

                return .just(response)
            }
    }
}


