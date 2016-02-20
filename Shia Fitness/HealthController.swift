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
    
    init(delegate: ViewController) {
        super.init()
        self.delegate = delegate
        
        
        
        
        
        
        let sampleType = HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate.distantPast(), endDate: NSDate(), options: HKQueryOptions.None)
        let sortDesc = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType!, predicate: predicate, limit: 1, sortDescriptors: [sortDesc]) { (sampleQuery, sample, error) -> Void in
            print("HERE")
            print(error)
            if let sample = sample?.first {
                print("sample:\(sample)")
            }
            
        }
        
        store.executeQuery(query)
    }
    
    
    func authorizeHealthKit(completion: ((success:Bool, error:NSError!) -> Void)!)
    {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead = Set(arrayLiteral:[
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierDateOfBirth)!,
            HKObjectType.characteristicTypeForIdentifier(HKCharacteristicTypeIdentifierBiologicalSex)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMass)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeight)!,
            HKObjectType.workoutType()
            ])
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite = Set(arrayLiteral: [HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierBodyMassIndex)!, HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,HKQuantityType.workoutType()])
        
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
    