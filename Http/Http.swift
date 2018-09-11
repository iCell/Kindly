//
//  Network.swift
//  Network
//
//  Created by iCell on 2018/8/17.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

public enum Response {
    case success(_ values: Any)
    case failure(_ error: Error)
}

public enum ResponseA<T> {
    case success(_ values: [T])
    case failure(_ error: Error)
}

public enum ResponseD<T> {
    case success(_ values: T)
    case failure(_ error: Error)
}

public final class Http {
    public static func fetchObject<T: Decodable>(_ target: TargetType, completion: ((ResponseD<T>) -> Void)?) {
        request(target) { res in
            switch res {
            case .success(let data):
                guard let data = data as? Data else {
                    completion?(ResponseD.failure(HttpError.invalidResponse))
                    return
                }
                do {
                    let result = try target.decoder.decode(T.self, from: data)
                    completion?(ResponseD.success(result))
                } catch {
                    completion?(ResponseD.failure(error))
                }
            case .failure(let error):
                completion?(ResponseD.failure(error))
            }
        }
    }
    
    public static func fetchObjects<T: Decodable>(_ target: TargetType, completion: ((ResponseA<T>) -> Void)?) {
        request(target) { res in
            switch res {
            case .success(let data):
                guard let data = data as? Data else {
                    completion?(ResponseA.failure(HttpError.invalidResponse))
                    return
                }
                do {
                    let result = try target.decoder.decode([T].self, from: data)
                    completion?(ResponseA.success(result))
                } catch {
                    completion?(ResponseA.failure(error))
                }
            case .failure(let error):
                completion?(ResponseA.failure(error))
            }
        }
    }
    
    public static func request(_ target: TargetType, completion: ((Response) -> Void)?) {
        do {
            let request = try target.urlRequest()
            URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    completion?(Response.failure(error))
                } else if let data = data {
                    completion?(Response.success(data))
                } else {
                    completion?(Response.failure(HttpError.invalidResponse))
                }
            }.resume()
        } catch {
            completion?(Response.failure(error))
        }
    }
}
