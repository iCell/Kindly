//
//  Wallet.swift
//  Wallet
//
//  Created by iCell on 2018/9/8.
//  Copyright © 2018 io.icell. All rights reserved.
//

import EOS
import ECC
import Http
import PromiseKit
import Foundation

public enum WalletError: Error {
    case comparePermissionAuthKeyFailed
}

public class Wallet {
    public static func accountFromPrivateKey(_ privateKey: String) -> Promise<Account> {
        return Promise<Account> { resolver in
            do {
                let priKey = try PrivateKey(key: privateKey)
                let pubKey = PublicKey(privateKey: priKey)
                let publicKey = pubKey.rawValue
                
                firstly { () -> Promise<AccountName> in
                    Http.object(target: EOS.getKeyAccount(publicKey: publicKey))
                }.then { names -> Promise<Account> in
                    let name = names.accountNames.joined()
                    return Http.object(target: EOS.getAccount(accountName: name))
                }.done { account in
                    let isValid = account.permissions
                        .map {$0.required_auth.keys}
                        .compactMap {$0}
                        .flatMap {$0}
                        .map{$0.key}
                        .filter{$0 == publicKey}
                        .isEmpty
                    if isValid {
                        resolver.fulfill(account)
                    } else {
                        resolver.reject(WalletError.comparePermissionAuthKeyFailed)
                    }
                }.catch { error in
                    resolver.reject(error)
                }
            } catch {
                resolver.reject(error)
            }
        }
    }
}
