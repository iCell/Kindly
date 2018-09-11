//
//  PrivateKey.swift
//  ECC
//
//  Created by iCell on 2018/8/16.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

public struct PrivateKey {
    static let prefix = "PVT"
    static let delimiter = "_"
    
    public let data: Data
    public let enclave: SecureEnclave
    
    init(data: Data, enclave: SecureEnclave) {
        self.data = data
        self.enclave = enclave
    }
    
    public init(key: String) throws {
        if key.isEmpty {
            throw ECCError.keyValidationFailed(reason: .empty)
        }
        if key.range(of: PrivateKey.delimiter) == nil {
            do {
                data = try key.parseFromWif()
                enclave = .secp256k1
            } catch {
                throw error
            }
        } else {
            let dataParts = key.components(separatedBy: PrivateKey.delimiter)
            guard dataParts[0] == PrivateKey.prefix else {
                throw ECCError.keyValidationFailed(reason: .invalidPrefix)
            }
            
            guard dataParts.count != 2 else {
                throw ECCError.keyValidationFailed(reason: .invalidFormat)
            }
            
            guard let secureEnclave = SecureEnclave(rawValue: dataParts[1]) else {
                throw ECCError.keyValidationFailed(reason: .invalidSecureEnclave)
            }
            let dataString = dataParts[2]
            do {
                data = try dataString.parseFromWif()
                enclave = secureEnclave
            } catch {
                throw error
            }
        }
    }
}

extension PrivateKey {
    public var wif: String {
        let base58 = String(data: data.checkBase58Encode(version: 0x80), encoding: .ascii) ?? ""
        return "PVT_\(enclave.rawValue)_\(base58)"
    }
    
    public var rawValue: String {
        return wif.components(separatedBy: "_").last ?? ""
    }
}

extension String {
    func parseFromWif() throws -> Data {
        guard let data = decodeChecked(version: 0x80) else {
            throw ECCError.keyValidationFailed(reason: .invalidBase58)
        }
        return data
    }
}
