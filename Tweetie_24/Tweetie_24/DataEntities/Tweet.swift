//
//  Tweet.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation
import RealmSwift
import Unbox

class Tweet: Object, Unboxable {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var text = ""
    @objc dynamic var name = ""
    @objc dynamic var created: Date?
    @objc dynamic var imageUrl = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience required init(unboxer: Unboxer) throws {
        self.init()
        
        id = try unboxer.unbox(key: "id")
        text = try unboxer.unbox(key: "text")
        name = try unboxer.unbox(keyPath: "user.name")
        created = try unboxer.unbox(key: "created_at", formatter: DateFormatter.twitter)
        imageUrl = try unboxer.unbox(keyPath: "user.profile_image_url_https")
    }
    
    static func unboxMany(tweets: [JSONObject]) -> [Tweet] {
        return (try? unbox(dictionaries: tweets, allowInvalidElements: true) as [Tweet]) ?? []
    }
    
}

