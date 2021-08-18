//
//  EOError.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/18.
//

import Foundation

enum EOError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
    case invalidDecoderConfiguration
}
