//
//  EventCell.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/12.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var details: UILabel!
    
    func configure(event: EOEvent) {
        title.text = event.title
        details.text = event.description
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        if let when = event.date {
            date.text = formatter.string(for: when)
        } else {
            date.text = ""
        }
    }
}
