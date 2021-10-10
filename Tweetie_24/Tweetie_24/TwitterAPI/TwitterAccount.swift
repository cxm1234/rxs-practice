//
//  TwitterAccount.swift
//  Tweetie_24
//
//  Created by xiaoming on 2021/10/10.
//

import Foundation

import RxSwift
import RxCocoa

import Alamofire
import Unbox

typealias AccessToken = String

struct TwitterAccount {
    static private var key: String = "placeholder"
    static private var secret: String = "placeholder"
    static var isLocal: Bool {
        return key == "placeholder"
    }
    
    private struct Token: Unboxable {
        let tokenString: String
        
        init(unboxer: Unboxer) throws {
            guard try unboxer.unbox(key: "token_type") == "bearer" else {
                throw Errors.invalidResponse
            }
            tokenString = try unboxer.unbox(key: "access_token")
        }
    }
    
    enum AccountStatus {
        case unavaliable
        case authorized(AccessToken)
    }
    
    enum Errors: Error {
        case UnableToGetToken, invalidResponse
    }
    
    private func oAuth2Token(completion: @escaping (String?) -> Void) -> DataRequest {
        
        let parameters: Parameters = ["grant_type": "client_credentials"]
        
        var headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"]
        
        if let authorizationHeader = HTTPHeader.authorization(username: TwitterAccount.key, password: TwitterAccount.secret) {
            headers[authorizationHeader.name] = authorizationHeader.value
        }
        
        return AF.request(
            "https://api.twitter.com/oauth2/token",
            method: .post,
            parameters: parameters,
            encoder: URLEncoding.httpBody,
            headers: headers
        ).responseJSON { response in
            guard response.error == nil,
                    let data = response.data,
                    let token: Token = try?
                    unbox(data: data) else {
                        completion(nil)
                        return
                    }
            completion(token.tokenString)
        }
    }
    
    var `default`: Driver<AccountStatus> {
//        return TwitterAccount.isLocal ? localA
    }
    
    private var localAccount: Driver<AccountStatus> {
        return Observable.create({ observer in
            observer.onNext(.authorized("localtoken"))
            return Disposables.create()
        })
            .asDriver(onErrorJustReturn: .unavaliable)
    }
    
    private var remoteAccount: Driver<AccountStatus> {
        return Observable.create({ observer in
            var request: DataRequest?
            
            if let storedToken = UserDefaults.standard.string(forKey: "token") {
                observer.onNext(.authorized(storedToken))
            } else {
                request = self.oAuth2Token(completion: { token in
                    guard let token = token else {
                        observable.onNext(.unavaliable)
                        return
                    }
                    UserDefaults.standard.set(token, forKey: "token")
                    observer.onNext(.authorized(token))
                })
            }
            
            return Disposables.create {
                request?.cancel()
            }
        })
            .asDriver(onErrorJustReturn: .unavaliable)
    }
}
