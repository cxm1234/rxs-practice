//
//  TweetCellView.swift
//  Tweetie_24
//
//  Created by  generic on 2021/10/25.
//

import UIKit

class TweetCellView: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UITextView!
    
    func update(with tweet: Tweet) {
        name.text = tweet.name
        message.text = tweet.text
        photo.setImage(with: URL(string: tweet.imageUrl))
    }

}
