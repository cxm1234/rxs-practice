//
//  GiphyGif.swift
//  iGif_17
//
//  Created by xiaoming on 2021/9/16.
//

import Foundation

struct GiphyGif: Decodable {
    let id: String
    let image: Image
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        let images = try container.nestedContainer(keyedBy: ImageKey.self, forKey: .images)
        self.image = try images.decode(Image.self, forKey: .fixHeight)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case images
    }
    
    enum ImageKey: String, CodingKey {
        case fixHeight = "fixed_height"
    }
}

extension GiphyGif {
    struct Image: Decodable {
        let height: String
        let width: String
        let url: URL
    }
}
