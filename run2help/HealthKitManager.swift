//
//  Pedometer.swift
//  run2help
//
//  Created by Arsalan Iravani on 30.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation
import CoreMotion
import HealthKit

class HealthKitManager {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    
    func main() {
        
        authorizeHealthKit { (success, error) in
            print("Successsss")
        }
        
        let sampleType = HKObjectType.workoutType()
        
        let startDate = NSDate() as Date
        let endDate = startDate.addingTimeInterval(-3600)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let limit = 0
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: [sortDescriptor]) { (query, results, error) in
            print(results ?? "no data")
        }
        
        healthKitStore.execute(query)
        
    }
    
    
    
    func readRunningWorkOuts(completion: @escaping (([AnyObject]?, Error?) -> () )) {
        
        // 1. Predicate to read only running workouts
        let predicate =  HKQuery.predicateForWorkouts(with: .running)
        // 2. Order the workouts by date
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType() , predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error) in
            if let queryError = error {
                print( "There was an error while reading the samples: \(queryError.localizedDescription)")
            }
            completion(results, error)
        }
        
        // 4. Execute the query
        healthKitStore.execute(sampleQuery)
        
    }
    
    
    func authorizeHealthKit(completion: @escaping ((_ success: Bool, _ error: NSError?) -> ())) {
        // 1. Set the types you want to read from HK Store
        let healthKitTypesToRead: Set<HKObjectType>? = [
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!, HKObjectType.characteristicType(forIdentifier: .bloodType)!, HKObjectType.characteristicType(forIdentifier: .biologicalSex)!, HKSampleType.workoutType()
        ]
        
        // 2. Set the types you want to write to HK Store
        let healthKitTypesToWrite: Set<HKSampleType>? = [
            HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!, HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!, HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!, HKQuantityType.workoutType()
        ]
        
        // Just in case OneHourWalker makes its way to an iPad... \
        if !HKHealthStore.isHealthDataAvailable() {
            _ = NSError(domain: "ru.techmas.techmasHealthKit", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not available in this Device"])
            return;
        }
        
        // Request authorization to read and/or write the specific data.
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) {
            (success, error) -> Void in
            
        }
    }
    
    
    
    
    func readMostRecentSample(sampleType:HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
        
        // 1. Build the Predicate
        let past = NSDate.distantPast as NSDate
        let now   = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: past as Date, end: now as Date, options: [])
        
        // 2. Build the sort descriptor to return the samples in descending order
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)
        // 3. we want to limit the number of samples returned by the query to just 1 (the most recent)
        let limit = 1
        
        // 4. Build samples query
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: mostRecentPredicate, limit: limit, sortDescriptors: [sortDescriptor]) {
            (sampleQuery, results, error ) -> Void in
            
            if error != nil {
                completion(nil, error! as NSError)
                return;
            }
            
            // Get the first sample
            let mostRecentSample = results?.first as? HKQuantitySample
            
            // Execute the completion closure
            if completion != nil {
                completion(mostRecentSample,nil)
            }
        }
        // 5. Execute the Query
        self.healthKitStore.execute(sampleQuery)
    }
    
    //    func updateWeight() {
    //        // 1. Construct an HKSampleType for weight
    //        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)
    //
    //        // 2. Call the method to read the most recent weight sample
    //        self.healthManager?.readMostRecentSample(sampleType, completion: { (mostRecentWeight, error) -> Void in
    //
    //            if( error != nil )
    //            {
    //                println("Error reading weight from HealthKit Store: \(error.localizedDescription)")
    //                return;
    //            }
    //
    //            var weightLocalizedString = self.kUnknownString;
    //            // 3. Format the weight to display it on the screen
    //            self.weight = mostRecentWeight as? HKQuantitySample;
    //            if let kilograms = self.weight?.quantity.doubleValueForUnit(HKUnit.gramUnitWithMetricPrefix(.Kilo)) {
    //                let weightFormatter = NSMassFormatter()
    //                weightFormatter.forPersonMassUse = true;
    //                weightLocalizedString = weightFormatter.stringFromKilograms(kilograms)
    //            }
    //
    //            // 4. Update UI in the main thread
    //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //                self.weightLabel.text = weightLocalizedString
    //                self.updateBMI()
    //
    //            });
    //        });
    //    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    func retrieveStepCount(completion: @escaping (_ stepRetrieved: Double) -> Void) {
        
        //   Define the Step Quantity Type
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        
        //   Get the start of the day
        let date = NSDate()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date as Date)
        
        //  Set the Predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate as Date, end: NSDate() as Date, options: .strictStartDate)
        let interval: NSDateComponents = NSDateComponents()
        interval.day = 1
        
        //  Perform the Query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents:interval as DateComponents)
        
        query.initialResultsHandler = { query, results, error in
            
            if error != nil {
                
                //  Something went Wrong
                return
            }
            
            //            if let myResults = results{
            //                myResults.enumerateStatistics(from: self.yesterday as Date, to: self.today as Date) {
            //                    statistics, stop in
            //
            //                    if let quantity = statistics.sumQuantity() {
            //
            //                        let steps = quantity.doubleValue(for: HKUnit.count())
            //
            //                        print("Steps = \(steps)")
            //                        completion(stepRetrieved: steps)
            //
            //                    }
            //                }
            //            }
            
            
        }
        
        
    }
    
    
    // let steps = NSSet(object: HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!)
    
    //    func recentSteps(completion: (Double, NSError?) -> () ) {
    //        // The type of data we are requesting (this is redundant and could probably be an enumeration
    //        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
    //
    //        // Our search predicate which will fetch data from now until a day ago
    //        // (Note, 1.day comes from an extension
    //        // You'll want to change that to your own NSDate
    //        let predicate = HKQuery.predicateForSamplesWithStartDate(NSDate() - 1.day, endDate: NSDate(), options: .None)
    //
    //        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
    //        let query = HKSampleQuery(sampleType: type, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
    //            var steps: Double = 0
    //
    //            if results?.count > 0
    //            {
    //                for result in results as [HKQuantitySample]
    //                {
    //                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
    //                }
    //            }
    //
    //            completion(steps, error)
    //        }
    //
    //        storage.executeQuery(query)
    //    }
    
    //    func getHeight(_ sampleType: HKSampleType , completion: ((HKSample?, NSError?) -> Void)!) {
    //
    //        // Predicate for the height query
    //        let distantPastHeight = Date.distantPast as Date
    //        let currentDate = Date()
    //        let lastHeightPredicate = HKQuery.predicateForSamples(withStart: distantPastHeight, end: currentDate, options: HKQueryOptions())
    //
    //        // Get the single most recent height
    //        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
    //
    //        // Query HealthKit for the last Height entry.
    //        let heightQuery = HKSampleQuery(sampleType: sampleType, predicate: lastHeightPredicate, limit: 1, sortDescriptors: [sortDescriptor]) { (sampleQuery, results, error ) -> Void in
    //
    //            if let queryError = error {
    //                //                    completion(nil, queryError)
    //                return
    //            }
    //
    //            // Set the first HKQuantitySample in results as the most recent height.
    //            let lastHeight = results!.first
    //
    //            if completion != nil {
    //                completion(lastHeight, nil)
    //            }
    //        }
    //
    //        // Time to execute the query.
    //        self.healthKitStore.execute(heightQuery)
    //    }
    //
    //    func saveDistance(_ distanceRecorded: Double, date: Date ) {
    //
    //        // Set the quantity type to the running/walking distance.
    //        let distanceType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)
    //
    //        // Set the unit of measurement to miles.
    //        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: distanceRecorded)
    //
    //        // Set the official Quantity Sample.
    //        let distance = HKQuantitySample(type: distanceType!, quantity: distanceQuantity, start: date, end: date)
    //
    //        // Save the distance quantity sample to the HealthKit Store.
    //        healthKitStore.save(distance, withCompletion: { (success, error) -> Void in
    //            if( error != nil ) {
    //                print(error)
    //            } else {
    //                print("The distance has been recorded! Better go check!")
    //            }
    //        })
    //    }
    
}
