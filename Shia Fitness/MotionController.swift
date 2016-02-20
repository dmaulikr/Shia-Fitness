//
//  MotionController.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation

class MotionController: CMMotionManager {
    var lessThanThresholdCount = 0
    var threshold = 0.23
    var sufficientMovement = false {
        didSet {
            if oldValue != sufficientMovement {
                print("SEEETTTT")
                if sufficientMovement {
                    delegate.setSufficient()
                } else {
                    delegate.setInSufficient()
                }
            }
        }
    }
    
    var stepCount = 0 {
        didSet {
            delegate.updateSteps()
        }
    }
    
    var allowed = false
    
    var delegate: ViewController!
    
    init(delegate: ViewController) {
        super.init()
        
        self.delegate = delegate
    }
    
    func start() {
        accelerometerUpdateInterval = 0.1
        startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (accData, error) -> Void in
            let a = accData?.acceleration
            let x = a!.x
            let y = a!.y
            let z = a!.z
            
            //print("x: \(x), y: \(y), z:\(z)")
            //print("\(x * y * z)")
            let calc = x * y * z
            if abs(calc) > self.threshold {
                self.lessThanThresholdCount = 0
            } else {
                self.lessThanThresholdCount++
            }
            
            if self.lessThanThresholdCount > 10 {
                self.sufficientMovement = false
            } else {
                self.sufficientMovement = true
            }
            
            //print(self.sufficientMovement)
            
            let stepCalc = (x * x) + (y * y) + (z * z)
            //print(stepCalc)
            if stepCalc > 1.3 && self.allowed {
                print("stepped")
                self.stepCount++
                self.allowed = false
            } else {
                if stepCalc < 0.8 {
                    self.allowed = true
                }
            }
            
        }
    }
    
    func stop() {
        stopAccelerometerUpdates()
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

/*
//
//  MotionController.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation

class MotionController: CMMotionManager {
var lessThanThresholdCount = 0
var threshold = 0.23
var sufficientMovement = false {
didSet {
if oldValue != sufficientMovement {
print("SEEETTTT")
if sufficientMovement {
delegate.setSufficient()
} else {
delegate.setInSufficient()
}
}
}
}
var allowed = true

var stepCount = 0 {
didSet {
delegate.updateSteps()
}
}

var delegate: ViewController!

init(delegate: ViewController) {
super.init()

self.delegate = delegate
}

func start() {
accelerometerUpdateInterval = 0.1
startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (accData, error) -> Void in
let a = accData?.acceleration
let x = a!.x
let y = a!.y
let z = a!.z

//print("x: \(x), y: \(y), z:\(z)")
//print("\(x * y * z)")
let calc = x * y * z
if abs(calc) > self.threshold {
self.lessThanThresholdCount = 0
} else {
self.lessThanThresholdCount++
}

if self.lessThanThresholdCount > 10 {
self.sufficientMovement = false
} else {
self.sufficientMovement = true
}

//print(self.sufficientMovement)

let stepCalc = (x * x) + (y * y) + (z * z)

//            if stepCalc > 1.3 && self.allowed {
//                print("stepped")
//                self.stepCount++
//                self.allowed = false
//            } else {
//                if stepCalc < 0.1 {
//                    self.allowed = true
//                }
//            }

}
}

func stop() {
stopAccelerometerUpdates()
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
override func drawRect(rect: CGRect) {
// Drawing code
}
*/

}


*/
