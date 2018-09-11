//
//  PublicKey.swift
//  ECC
//
//  Created by iCell on 2018/8/16.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

import ECC.UECC

public struct PublicKey {
    public let data: Data
    public let enclave: SecureEnclave
    
    public init(privateKey: PrivateKey) {
        var bytes = Array(repeating: UInt8(0), count: 64)
        var compressBytes = Array(repeating: UInt8(0), count: 33)
        
        let curve: uECC_Curve
        switch privateKey.enclave {
        case .secp256k1:
            curve = uECC_secp256k1()
        case .secp256r1:
            curve = uECC_secp256r1()
        }
        uECC_compute_public_key([UInt8](privateKey.data), &bytes, curve)
        uECC_compress(&bytes, &compressBytes, curve)
        
        enclave = privateKey.enclave
        data = Data(bytes: compressBytes, count: 33)
    }
}

extension PublicKey {
    public var wif: String {
        return encoded()
    }
    
    public var rawValue: String {
        guard let withoutDelimiter = wif.components(separatedBy: "_").last else {
            return ""
        }
        guard withoutDelimiter.hasPrefix("EOS") else {
            return "EOS\(withoutDelimiter)"
        }
        return withoutDelimiter
    }
}

extension PublicKey {
    func encoded() -> String {
        let bytesSize = 4
        let hashSize = data.count
        var datas = Array(repeating: UInt8(0), count: bytesSize + hashSize)
        var bytes = [UInt8](data)
        for index in 0..<hashSize {
            datas[index] = bytes[index]
        }
        let hash = RMD(&bytes, 33)
        for index in 0..<bytesSize {
            datas[hashSize + index] = hash![index]
        }
        let base58 = Data(bytes: datas, count: bytesSize + hashSize).base58Encode()
        let base58Str = String(data: base58, encoding: .ascii) ?? ""
        return "PUB_\(enclave.rawValue)_\(base58Str)"
    }
}
