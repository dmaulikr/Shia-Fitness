//
//  XView.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit

class XView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        userInteractionEnabled = false
        backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.4)
        let imageView = UIImageView(image: UIImage(named: "an_x"))
        imageView.frame = CGRectMake(0, 0, 100, 100)
        imageView.center = center
//        imageView.alpha = 0.8
        imageView.userInteractionEnabled = false
        addSubview(imageView)
        
        let label = UILabel()
        label.text = "Insufficient Movement"
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        label.sizeToFit()
//        label.alpha = 
        label.userInteractionEnabled = false
        label.center = CGPointMake(frame.size.width / 2, (frame.size.height / 2) + 75)
        addSubview(label)
    }
    


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
