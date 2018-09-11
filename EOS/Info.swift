//
//  Info.swift
//  EOS
//
//  Created by iCell on 2018/8/18.
//  Copyright © 2018 io.icell. All rights reserved.
//

import Foundation

public struct Info: Codable {
    public let serverVersion: String
    public let chainId: String
    public let headBlockNum: Int
    public let lastIrreversibleBlockNum: Int
    public let lastIrreversibleBlockId: String
    public let headBlockId: String
    public let headBlockTime: Date
    public let headBlockProducer: String
    public let virtualBlockCpuLimit: Int
    public let virtualBlockNetLimit: Int
    public let blockCpuLimit: Int
    public let blockNetLimit: Int
}
