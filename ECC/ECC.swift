//
//  ECC.swift
//  ECC
//
//  Created by iCell on 2018/8/16.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

public enum SecureEnclave: String {
    case secp256k1 = "K1"
    case secp256r1 = "R1"
    
    var curve: uECC_Curve {
        switch self {
        case .secp256k1:
            return uECC_secp256k1()
        case .secp256r1:
            return uECC_secp256r1()
        }
    }
}

public enum ECCError: Error {
    public enum KeyValidationFailedReason {
        case empty
        case invalidPrefix
        case invalidFormat
        case invalidBase58
        case invalidSecureEnclave
    }
    
    case keyGeneratorFailed
    case keyValidationFailed(reason: KeyValidationFailedReason)
}

public struct Pair {
    let publicKey: PublicKey
    let privateKey: PrivateKey
}

public final class ECC {
    public static func isKeyStringValid(_ keyString: String) -> Bool {
        if keyString.range(of: PrivateKey.delimiter) == nil {
            return keyString.count == 51
        } else {
            let dataParts = keyString.components(separatedBy: PrivateKey.delimiter)
            guard dataParts.count != 2 else {
                return false
            }
            guard dataParts[0] == PrivateKey.prefix else {
                return false
            }
            guard dataParts[1].count == 51 else {
                return false
            }
            return true
        }
    }
    
    public static func randomPair(enclava: SecureEnclave = .secp256k1) -> Pair? {
        guard let privateKey = randomPrivateKey(enclave: enclava) else {
            return nil
        }
        let publicKey = PublicKey(privateKey: privateKey)
        return Pair(publicKey: publicKey, privateKey: privateKey)
    }
    
    public static func randomPrivateKey(enclave: SecureEnclave = .secp256k1) -> PrivateKey? {
        var data = Data(count: 32)
        let result = data.withUnsafeMutableBytes { bytes -> Int32 in
            return SecRandomCopyBytes(kSecRandomDefault, 32, bytes)
        }
        if result == errSecSuccess {
            return PrivateKey(data: data, enclave: enclave)
        } else {
            return nil
        }
    }
}
