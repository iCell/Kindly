//
//  NetworkError.swift
//  Network
//
//  Created by iCell on 2018/8/17.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

public enum HttpError: Error {
    public enum ParameterEncodingFailedReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
    }
    
    case parameterEncodingFailed(reason: ParameterEncodingFailedReason)
    case invalidResponse
}
