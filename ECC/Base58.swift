//
//  PublicKey.swift
//  ECC
//
//  Created by iCell on 2018/8/16.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation
import Security
import CommonCrypto

import ECC.UECC
import ECC.Base58
import ECC.RipeMD

let setSHA256Implementation: Void = {
    b58_sha256_impl = ccSha256
}()

func ccSha256(_ digest: UnsafeMutableRawPointer?, _ data: UnsafeRawPointer?, _ size: Int) -> Bool {
    let opaquePtr = OpaquePointer(digest)
    return CC_SHA256(data, CC_LONG(size), UnsafeMutablePointer<UInt8>(opaquePtr)).pointee != 0
}

extension String {
    public func decodeChecked(version: UInt8) -> Data? {
        _ = setSHA256Implementation
        let source = self.data(using: .utf8)!
        
        var bin = [UInt8](repeating: 0, count: source.count)
        
        var size = bin.count
        let success = source.withUnsafeBytes { (sourceBytes: UnsafePointer<CChar>) -> Bool in
            if se_b58tobin(&bin, &size, sourceBytes, source.count) {
                bin = Array(bin[(bin.count - size)..<bin.count])
                return se_b58check(bin, size, sourceBytes, source.count) == Int32(version)
            }
            return false
        }
        guard success else { return nil }
        return Data(bytes: bin[1..<(bin.count-4)])
    }
}

extension Data {
    func sha256() -> Data {
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        withUnsafeBytes {
            _ = CC_SHA256($0, CC_LONG(count), &hash)
        }
        return Data(bytes: hash)
    }
    
    public func base58Encode() -> Data {
        var mult = 2
        while true {
            var enc = Data(repeating: 0, count: self.count * mult)
            let s = withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Data? in
                var size = enc.count
                let success = enc.withUnsafeMutableBytes {
                    se_b58enc($0, &size, bytes, self.count)
                }
                guard success else { return nil }
                return enc.subdata(in: 0..<(size-1))
            }
            if let s = s {
                return s
            }
            mult += 1
        }
    }
    
    public func checkBase58Encode(version: UInt8) -> Data {
        _ = setSHA256Implementation
        var enc = Data(repeating: 0, count: self.count * 3)
        return withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Data? in
            var size = enc.count
            
            let success = enc.withUnsafeMutableBytes { ptr -> Bool in
                return se_b58check_enc(ptr, &size, version, bytes, self.count)
            }
            guard success else {
                fatalError()
            }
            return enc.subdata(in: 0..<(size-1))
        }!
    }
    
    public static func base58Decode(_ base58: String) -> Data? {
        let source = base58.data(using: .utf8)!
        var bin = [UInt8](repeating: 0, count: source.count)
        var size = bin.count
        
        let success = source.withUnsafeBytes { (sourceBytes: UnsafePointer<CChar>) -> Bool in
            return se_b58tobin(&bin, &size, sourceBytes, source.count)
        }
        if !success {
            return nil
        }
        return Data(bytes: bin[(bin.count - size)..<bin.count])
    }
}
