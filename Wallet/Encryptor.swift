//
//  Encryptor.swift
//  Wallet
//
//  Created by iCell on 2018/9/9.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation
import Heimdall

public enum EncryptError: Error {
    case initializeFailed
    case encryptFailed
    case decryptFailed
}

open class Encryptor {
    private let encryptor: Heimdall
    
    public init(publicKey: String, password: String) throws {
        guard let encryptor = Heimdall(publicTag: publicKey, privateTag: password) else {
            throw EncryptError.initializeFailed
        }
        self.encryptor = encryptor
    }
    
    public func encrypt(privateKey: String) throws -> String {
        guard let encrypted = encryptor.encrypt(privateKey) else {
            throw EncryptError.encryptFailed
        }
        return encrypted
    }
    
    public func decrypt(encrpted: String) throws -> String {
        guard let result = encryptor.decrypt(encrpted) else {
            throw EncryptError.decryptFailed
        }
        return result
    }
}
