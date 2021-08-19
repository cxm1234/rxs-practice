//
//  EONET.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/18.
//

import Foundation
import RxSwift
import RxCocoa

class EONET {
    static let API = "https://eonet.sci.gsfc.nasa.gov/api/v2.1"
    static let categoriesEndpoint = "/categories"
    static let eventsEndpoint = "/events"
    
    static func jsonDecoder(contentIdentifier: String) -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.userInfo[.contentIdentifier] = contentIdentifier
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    static func filteredEvents(events: [EOEvent], forCategory category: EOCategory) -> [EOEvent] {
        return events.filter { event in
            return event.categories.contains(where: { $0.id == category.id }) &&
                !category.events.contains {
                    $0.id == event.id
                }
        }
        .sorted(by: EOEvent.compareDates)
    }
    
    static func request<T: Decodable>(endpoint: String, query: [String: Any] = [:], contentIdentifier: String) -> Observable<T> {
        do {
            guard let url = URL(string: API)?.appendingPathComponent(endpoint),
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
                throw EOError.invalidURL(endpoint)
            }
            components.queryItems = try query.compactMap({ (key, value) in
                guard let v = value as? CustomStringConvertible else {
                    throw EOError.invalidParameter(key, value)
                }
                return URLQueryItem(name: key, value: v.description)
            })
            guard let finalURL = components.url else {
                throw EOError.invalidURL(endpoint)
            }
            let request = URLRequest(url: finalURL)
            
            return URLSession.shared.rx.response(request: request)
                .map { (result: (response: HTTPURLResponse, data: Data)) -> T in
                    let decoder = self.jsonDecoder(contentIdentifier: contentIdentifier)
                    let envelope = try decoder.decode(EOEnvelope<T>.self, from: result.data)
                    return envelope.content
                }
        } catch {
            return Observable.empty()
        }
    }
    
    static var categories: Observable<[EOCategory]> = {
        let request: Observable<[EOCategory]> = EONET.request(endpoint: categoriesEndpoint, contentIdentifier: "categories")
        
        return request.map {
            categories in categories.sorted { $0.name < $1.name }
        }
        .catchErrorJustReturn([])
        .share(replay: 1, scope: .forever)
    }()
}


