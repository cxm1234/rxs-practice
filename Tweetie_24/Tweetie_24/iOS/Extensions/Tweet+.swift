//
//  Tweet.swift
//  Tweetie_24
//
//  Created by  generic on 2021/10/26.
//

import RxDataSources

extension Tweet: IdentifiableType {
    typealias Identity = Int64
    public var identity: Int64 { return id }
}
