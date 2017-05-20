//
//  PedometerViewController.swift
//  run2help
//
//  Created by Arsalan Iravani on 30.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class TimerViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    
    var zeroTime = TimeInterval()
    var timer : Timer = Timer()
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    
    let healthManager:HealthKitManager = HealthKitManager()
    var height: HKQuantitySample?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Need to Enable Location")
        }
        
        // We cannot access the user's HealthKit data without specific permission.
//        getHealthKitPermission()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
//    func getHealthKitPermission() {
//        
//        // Seek authorization in HealthKitManager.swift.
//        healthManager.authorizeHealthKit { (authorized,  error) -> Void in
//            if authorized {
//                
//                // Get and set the user's height.
//                self.setHeight()
//            } else {
//                if error != nil {
//                    print(error)
//                }
//                print("Permission denied.")
//            }
//        }
//    }
    
    @IBAction func startTimer(_ sender: AnyObject) {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(TimerViewController.updateTime), userInfo: nil, repeats: true)
        zeroTime = Date.timeIntervalSinceReferenceDate
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func stopTimer(_ sender: AnyObject) {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func updateTime() {
        let currentTime = Date.timeIntervalSinceReferenceDate
        var timePassed: TimeInterval = currentTime - zeroTime
        let minutes = UInt8(timePassed / 60.0)
        timePassed -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(timePassed)
        timePassed -= TimeInterval(seconds)
        let millisecsX10 = UInt8(timePassed * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strMSX10 = String(format: "%02d", millisecsX10)
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strMSX10)"
        
        if timerLabel.text == "60:00:00" {
            timer.invalidate()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation.distance(from: locations.last as CLLocation!)
            distanceTraveled += lastDistance * 0.000621371
            
            let trimmedDistance = String(format: "%.2f", distanceTraveled)
            
            milesLabel.text = "\(trimmedDistance) Miles"
        }
        
        lastLocation = locations.last as CLLocation!
    }
    
//    func setHeight() {
//        // Create the HKSample for Height.
//        let heightSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)
//        
//        // Call HealthKitManager's getSample() method to get the user's height.
//        self.healthManager.getHeight(heightSample!, completion: { (userHeight, error) -> Void in
//            
//            if( error != nil ) {
//                print("Error: \(error!.localizedDescription)")
//                return
//            }
//            
//            var heightString = ""
//            
//            self.height = userHeight as? HKQuantitySample
//            
//            // The height is formatted to the user's locale.
//            if let meters = self.height?.quantity.doubleValue(for: HKUnit.meter()) {
//                let formatHeight = LengthFormatter()
//                formatHeight.isForPersonHeightUse = true
//                heightString = formatHeight.string(fromMeters: meters)
//            }
//            
//            // Set the label to reflect the user's height.
//            DispatchQueue.main.async(execute: { () -> Void in
//                self.heightLabel.text = heightString
//            })
//        })
//        
//    }
//    
//    @IBAction func share(_ sender: AnyObject) {
//        healthManager.saveDistance(distanceTraveled, date: Date())
//    }
    
}
