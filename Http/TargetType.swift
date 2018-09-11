//
//  TargetType.swift
//  Network
//
//  Created by iCell on 2018/8/17.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

public protocol TargetType {
    
    /// The target's base `URL`.
    var baseURL: URL { get }
    
    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }
    
    /// The HTTP method used in the request.
    var method: HTTPMethod { get }
    
    /// The parameters to be encoded in the request.
    var parameters: Parameters? { get }
    
    var dateFormatter: DateFormatter? { get }
}

extension TargetType {
    var dateFormatter: DateFormatter? {
        return nil
    }
    
    var decoder: JSONDecoder {
        let jsonDecoder = JSONDecoder()
        if let formatter = dateFormatter {
            jsonDecoder.dateDecodingStrategy = .formatted(formatter)
        }
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
    
    public func urlRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        do {
            request = try JSONEncoding().encode(request, with: parameters)
        } catch {
            throw error
        }
        return request
    }
}
