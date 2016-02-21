//
//  LocationController.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit
import CoreLocation

class LocationController: CLLocationManager, CLLocationManagerDelegate {
    var noteDelegate: ViewController!
    
    var totalDistance: CLLocationDistance = 0 {
        didSet {
            if totalDistance - oldValue > 1 {
                noteDelegate.updateDistance()
            }
        }
    }
    
    var oldLocation: CLLocation?
    
    init(noteDelegate: ViewController) {
        super.init()
        
        delegate = self
        self.noteDelegate = noteDelegate
        requestAlwaysAuthorization()
        desiredAccuracy = kCLLocationAccuracyBest
        activityType = CLActivityType.Fitness
        distanceFilter = 10
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLoc = locations.first!
        if let old = oldLocation {
            let meters = newLoc.distanceFromLocation(old)
            totalDistance += meters
            print("totalDistance: \(totalDistance)")
        }
        
        oldLocation = newLoc
    }

}
