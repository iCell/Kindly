//
//  Account.swift
//  EOS
//
//  Created by iCell on 2018/9/8.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

public struct AccountName: Codable {
    public let accountNames: [String]
}

public struct Account: Codable {
    public let accountName: String
    public let headBlockNum: Int
    public let headBlockTime: Date
    public let privileged: Bool
    public let lastCodeUpdate: Date
    public let created: Date
    public let coreLiquidBalance: String
    public let ramQuota: Double
    public let netWeight: Double
    public let cpuWeight: Double
    public let netLimit: Limit
    public let cpuLimit: Limit
    public let ramUsage: Double
    public let totalResources: Resource
    public let selfDelegatedBandwidth: BandWidth
    public let refundRequest: RefundRequest
    public let voterInfo: VoterInfo
    public let permissions: [Permission]
}

public struct Limit: Codable {
    public let used: Double
    public let available: Double
    public let max: Double
}

public struct Resource: Codable {
    public let owner: String
    public let netWeight: String
    public let cpuWeight: String
    public let ramBytes: Double
}

public struct RefundRequest: Codable {
    public let owner: String
    public let requestTime: String
    public let netAmount: String
    public let cpuAmount: String
}

public struct BandWidth: Codable {
    public let from: String
    public let to: String
    public let netWeight: String
    public let cpuWeight: String
}

public struct VoterInfo: Codable {
    public let owner: String
    public let proxy: String
    public let producers: [String]
    public let staked: Double
    public let lastVoteWeight: String
    public let proxiedVoteWeight: String
    public let isProxy: Int
}

public struct Permission: Codable {
    public let permName: String
    public let parent: String
    public let required_auth: Auth
    
    public struct Auth: Codable {
        public let threshold: Int
        public let keys: [Key]
    }
    
    public struct Key: Codable {
        public let key: String
        public let Weight: Int
    }
}
