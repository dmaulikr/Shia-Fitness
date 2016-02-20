//
//  SqueezeButton.swift
//  Expense Tracker
//
//  Created by Omar Alejel on 6/30/15.
//  Copyright © 2015 omar alejel. All rights reserved.
//

import UIKit


class SqueezeButton: UIButton {
    var completedSqueeze = true
    var pendingOut = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        press()
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        rescaleButton()
    }
    
    func press() {
        UIView.animateKeyframesWithDuration(0.1, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
            self.completedSqueeze = false
            self.transform = CGAffineTransformScale(self.transform, 0.9, 0.9)
            }) { (done) -> Void in
                self.completedSqueeze = true
                if self.pendingOut {
                    self.rescaleButton()
                    self.pendingOut = false
                }
        }
    }
    
    func rescaleButton() {
        if completedSqueeze {
            UIView.animateKeyframesWithDuration(0.2, delay: 0.0, options: UIViewKeyframeAnimationOptions.CalculationModeCubic, animations: { () -> Void in
                self.transform = CGAffineTransformScale(self.transform, 1/0.9, 1/0.9)
                }) { (done) -> Void in
                    
            }
        } else {
            pendingOut = true
        }
    }
}
