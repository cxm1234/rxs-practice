//
//  TwitterAPI.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation

import RxSwift
import RxCocoa

import Alamofire

typealias JSONObject = [String: Any]
typealias ListIdentifier = (username: String, slug: String)

protocol TwitterAPIProtocol {
    static func timeline(of username: String) -> (AccessToken, TimeLineCursor) ->           Observable<[JSONObject]>
    static func timeline(of list: ListIdentifier) -> (AccessToken, TimeLineCursor) -> Observable<[JSONObject]>
    static func members(of list: ListIdentifier) -> (AccessToken) -> Observable<[JSONObject]>
}

struct TwitterAPI: TwitterAPIProtocol {
    
    fileprivate enum Address: String {
        case timeline = "statuses/user_timeline.json"
        case listFeed = "lists/statuses.json"
        case listMembers = "lists/members.json"
        
        private var baseURL: String {
            return "https://api.twitter.com/1.1/"
        }
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    enum Errors: Error {
        case requestFailed
    }
    
    static func timeline(of username: String) -> (AccessToken, TimeLineCursor) -> Observable<[JSONObject]> {
        return { account, cursor in
            return request(account, address: TwitterAPI.Address.timeline, parameters: [
                "screen_name": username, "contributor_details": false, "count": "100", "include_rts": "true"
            ])
        }
    }
    
    
}
