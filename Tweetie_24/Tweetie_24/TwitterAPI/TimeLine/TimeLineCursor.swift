//
//  TimeLineCursor.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation

struct TimeLineCursor {
    let maxId: Int64
    let sinceId: Int64
    
    init(max: Int64, since: Int64) {
        maxId = max
        sinceId = since
    }
    
    static var none: TimeLineCursor {
        return TimeLineCursor(max: Int64.max, since: 0)
    }
}

extension TimeLineCursor: CustomStringConvertible {
    var description: String {
        return "[max \(maxId), since: \(sinceId)]"
    }
}

extension TimeLineCursor: Equatable {
    static func ==(lhs: TimeLineCursor, rhs: TimeLineCursor) -> Bool {
        return lhs.maxId==rhs.maxId && lhs.sinceId==rhs.sinceId
    }
}
