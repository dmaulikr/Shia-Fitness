//
//  HealthController.swift
//  Shia Fitness
//
//  Created by Omar Alejel on 2/20/16.
//  Copyright © 2016 omaralejel. All rights reserved.
//

import UIKit
import HealthKit

class HealthController: NSObject {
    var delegate: ViewController!
    let store = HKHealthStore()
    
    var timer: NSTimer!
    
    init(delegate: ViewController) {
        super.init()
        self.delegate = delegate
        
        authorizeHealthKit { (success, error) -> Void in
            self.observeHeartRate()
        }
    }
    
    func observeHeartRate() {
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate().dateByAddingTimeInterval(-8), endDate: NSDate.distantFuture(), options: HKQueryOptions.None)
        let query = HKObserverQuery(sampleType: sampleType!, predicate: predicate) { (observerQuery, observerQueryCompletionHandler, error) -> Void in
            print("OBSERVING")
            self.getRecentHeartRate()
        }
        
        store.executeQuery(query)
        
        if timer == nil {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("observeHeartRate"), userInfo: nil, repeats: true)
            })
        }
        
    }
    
    func getRecentHeartRate() {
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate.distantPast(), endDate: NSDate(), options: HKQueryOptions.None)
        let sortDesc = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: 10, sortDescriptors: [sortDesc]) { (sampleQuery, sample, error) -> Void in
            if let sample = sample?.first as? HKQuantitySample {
                print("GOT A HEART RATE!")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.delegate.animateHeartWithRate(Float(sample.quantity.doubleValueForUnit(HKUnit(fromString: "count/min"))))
                })
            }
        }
        
        store.executeQuery(query)
    }
    
    
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = Set(arrayLiteral:
            HKSampleType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKSampleType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
            HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKSampleType.workoutType())
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite: Set<HKSampleType> = Set(arrayLiteral: HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!, HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,HKSampleType.workoutType())
        
        // 3. If the store is not available (for instance, iPad) return an error and don't go on.
        if !HKHealthStore.isHealthDataAvailable()
        {
            let error = NSError(domain: "domain....", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            if( completion != nil )
            {
                completion(success:false, error:error)
            }
            return;
        }
        
        // 4.  Request HealthKit authorization

        store.requestAuthorizationToShareTypes(healthKitTypesToWrite, readTypes: healthKitTypesToRead) { (success, error) -> Void in
            
            if( completion != nil )
            {
                completion(success:success,error:error)
            }
        }
    }
}
    