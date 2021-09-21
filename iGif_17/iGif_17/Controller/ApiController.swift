//
//  ApiController.swift
//  iGif_17
//
//  Created by  generic on 2021/9/17.
//

import Foundation
import RxSwift

class ApiController {
    static let shared = ApiController()
    
    private let apiKey = "RmBBAiXMMarfj17jubeJUJjNxo2R1xPA"
    
    func search(text: String) -> Observable<[GiphyGif]> {
        let url = URL(string: "http://api.giphy.com/v1/gifs/search")
        
        return Observable.just([])
    }
}
