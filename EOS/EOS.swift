//
//  EOS.swift
//  EOS
//
//  Created by iCell on 2018/8/14.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation
import Http

public enum EOS {
    case getInfo
    case getAccount(accountName: String)
    case getKeyAccount(publicKey: String)
    case getTransaction(publicKey: String)
    case getTokens(code: String, account: String)
}

extension EOS: TargetType {
    public var baseURL: URL {
        return URL(string: "https://api.eosrio.io")!
    }

    public var path: String {
        switch self {
        case .getAccount:
            return "/v1/chain/get_account"
        case .getKeyAccount:
            return "/v1/history/get_key_accounts"
        case .getTransaction:
            return "/v1/history/get_transaction"
        case .getTokens:
            return "/v1/chain/get_currency_balance"
        case .getInfo:
            return "/v1/chain/get_info"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getInfo:
            return .get
        case .getAccount, .getKeyAccount, .getTransaction, .getTokens:
            return .post
        }
    }

    public var parameters: Parameters? {
        switch self {
        case .getAccount(let accountName):
            return ["account_name": accountName]
        case .getKeyAccount(let publicKey):
            return ["public_key": publicKey]
        case .getTokens(let code, let account):
            return ["code": code, "account": account]
        default:
            return nil
        }
    }
    
    public var dateFormatter: DateFormatter? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return formatter
    }
}
