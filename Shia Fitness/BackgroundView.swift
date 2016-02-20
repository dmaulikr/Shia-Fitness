//
//  BackgroundView.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let imageView = UIImageView(frame: rect)
        imageView.image = UIImage(named: "bg_space")
        addSubview(imageView)
        imageView.contentMode = .ScaleAspectFill
    }


}
