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
            return request(
                account,
                address: TwitterAPI.Address.timeline,
                parameters: [
                "screen_name": username,
                "contributor_details": "false",
                "count": "100",
                "include_rts": "true"
            ])
        }
    }
    
    static private func request<T: Any>(
        _ token: AccessToken,
        address: Address,
        parameters: [String: String] = [:]
    ) -> Observable<T> {
        return Observable.create { observer in
            var comps = URLComponents(string: address.url.absoluteString)!
            comps.queryItems = parameters.sorted{ $0.0 < $1.0 }.map(URLQueryItem.init)
            let url = try! comps.asURL()
            
            guard !TwitterAccount.isLocal else {
                if let cachedFileURL = Bundle.main.url(forResource: url.safeLocalRepresentation.lastPathComponent, withExtension: nil),
                   let data = try? Data(contentsOf: cachedFileURL),
                   let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? T) as T??),
                   let result = json {
                    observer.onNext(result)
                }
                observer.onCompleted()
                return Disposables.create()
            }
            
            let request = AF.request(
                url.absoluteString,
                method: .get,
                parameters: Parameters(),
                encoding: URLEncoding.httpBody,
                headers: ["Authorization": "Bearer \(token)"]
            )
            
            request.responseJSON { response in
                guard response.error == nil,
                      let data = response.data,
                      let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? T) as T??),
                      let result = json else {
                          observer.onError(Errors.requestFailed)
                          return
                      }
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create{
                request.cancel()
            }
            
        }
    }
    
}

extension String {
    var safeFileNameRepresentation: String {
        return replacingOccurrences(of: "?", with: "-")
            .replacingOccurrences(of: "&", with: "-")
            .replacingOccurrences(of: "=", with: "-")
    }
}

extension URL {
    var safeLocalRepresentation: URL {
        return URL(string: absoluteString.safeFileNameRepresentation)!
    }
}
