//
//  EOEvent.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/18.
//

import Foundation

struct EOEventCategory: Decodable {
    let id: Int
    let title: String
}

struct EOEvent: Decodable {
    let id: String
    let title: String
    let description: String
    let link: URL?
    let closeDate: Date?
    let categories: [EOEventCategory]
    let locations: [EOLocation]?
    var date: Date? {
        return closeDate ?? locations?.compactMap(\.date).first
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, description, link, closeDate = "closed", categories, locations = "geometries"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        link = try container.decode(URL?.self, forKey: .link)
        closeDate = try container.decode(Date.self, forKey: .closeDate)
        categories = try container.decode([EOEventCategory].self, forKey: .categories)
        locations = try? container.decode([EOLocation].self, forKey: .locations)
        
    }
    
    static func compareDates(lhs: EOEvent, rhs: EOEvent) -> Bool {
        switch (lhs.date, rhs.date) {
        case (nil, nil): return false
        case (nil, _): return true
        case (_, nil): return false
        case (let ldate, let rdate): return ldate! < rdate!
        }
    }
}
