//
//  DownloadView.swift
//  OurPlanet_10
//
//  Created by xiaoming on 2021/8/26.
//

import UIKit

class DownloadView: UIStackView {
    
    let label = UILabel()
    let progress = UIProgressView()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        translatesAutoresizingMaskIntoConstraints = false
        
        axis = .horizontal
        spacing = 0
        distribution = .fillEqually
        
        if let superview = superview {
            backgroundColor = .white
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            heightAnchor.constraint(equalToConstant: 30).isActive = true
            
            label.text = "Downloads"
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = .lightGray
            label.textAlignment = .center
            
            progress.translatesAutoresizingMaskIntoConstraints = false
            
            let progressWrap = UIView()
            progressWrap.translatesAutoresizingMaskIntoConstraints = false
            progressWrap.backgroundColor = .lightGray
            progressWrap.addSubview(progress)
            
            progress.leftAnchor.constraint(equalTo: progressWrap.leftAnchor).isActive = true
            progress.rightAnchor.constraint(equalTo: progressWrap.rightAnchor, constant: -10).isActive = true
            progress.heightAnchor.constraint(equalToConstant: 4).isActive = true
            progress.centerYAnchor.constraint(equalTo: progressWrap.centerYAnchor).isActive = true
            
            addArrangedSubview(label)
            addArrangedSubview(progressWrap)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
