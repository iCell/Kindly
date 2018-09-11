//
//  AccountManager.swift
//  Wallet
//
//  Created by iCell on 2018/9/9.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation
import PromiseKit
import EOS

private let kAccountStoreKey = "kAccountStoreKey"

open class AccountManager {
    public static let shared: AccountManager = AccountManager()
    
    var account: Account? {
        guard let account = UserDefaults.standard.object(forKey: kAccountStoreKey) as? Account else {
            return nil
        }
        return account
    }
    
    func importPrivateKey(_ privateKey: String) -> Promise<Void> {
        return Wallet
            .accountFromPrivateKey(privateKey)
            .done { account in
                UserDefaults.standard.set(account, forKey: kAccountStoreKey)
            }
    }
}
