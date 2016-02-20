//
//  ArcView.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit

class ArcView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        let w = frame.size.width
        let h = frame.size.height
        
        backgroundColor = UIColor.clearColor()
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, h))
        path.addQuadCurveToPoint(CGPointMake(w, h), controlPoint: CGPointMake(w / 2, 0 - h))
        path.addQuadCurveToPoint(CGPointMake(0, h), controlPoint: CGPointMake(w / 2, 0 - (h / 3)))
        
        let shape = CAShapeLayer()
        shape.path = path.CGPath
        shape.fillColor = UIColor.whiteColor().CGColor
        
        shape.shadowColor = UIColor.whiteColor().CGColor
        shape.shadowOpacity = 0.5
        shape.shadowOffset = CGSizeMake(0, 0)
        shape.shadowRadius = 5
        
        layer.addSublayer(shape)
    }
    
    override init(frame: CGRect) {
        // Drawing code
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
