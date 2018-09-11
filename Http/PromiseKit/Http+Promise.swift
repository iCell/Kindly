//
//  Http+Promise.swift
//  Http
//
//  Created by iCell on 2018/8/31.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation
import PromiseKit

extension Http {
    public static func object<T: Decodable>(target: TargetType) -> Promise<T> {
        return Promise<T> { resolver in
            fetchObject(target) { (res: ResponseD<T>) in
                switch res {
                case .success(let object):
                    resolver.fulfill(object)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
    
    public static func objects<T: Decodable>(target: TargetType) -> Promise<[T]> {
        return Promise<[T]> { resolver in
            fetchObjects(target) { (res: ResponseA<T>) in
                switch res {
                case .success(let objects):
                    resolver.fulfill(objects)
                case .failure(let error):
                    resolver.reject(error)
                }
            }
        }
    }
}
