//
//  DateFormatter+Twitter.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation

extension DateFormatter {
    static let twitter = DateFormatter(dateFormat: "EEE MMM dd HH:mm:ss Z yyyy")
    
    convenience init(dateFormat: String) {
        self.init()
        self.dateFormat = dateFormat
    }
}
