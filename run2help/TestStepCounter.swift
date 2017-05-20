//
//  TestStepCounter.swift
//  run2help
//
//  Created by Arsalan Iravani on 21.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var activityState: UILabel!
    @IBOutlet weak var steps: UILabel!
    
    var days:[String] = []
    var stepsTaken:[Int] = []
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cal = NSCalendar.current
        let setOfComponents: Set<Calendar.Component> = [Calendar.Component.year]
        var components = cal.dateComponents(setOfComponents, from: Date())
        
//        var comps = cal.component(.year , from: Date())
//            .components(NSCalendar.Unit.YearCalendarUnit | .MonthCalendarUnit | .DayCalendarUnit | .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit, fromDate: NSDate())
        
        components.hour = 0
        components.minute = 0
        components.second = 0
        let timeZone = NSTimeZone.system
        cal.timeZone = timeZone
        
        let midnightOfToday = cal.date(from: components)
        
        
        if(CMMotionActivityManager.isActivityAvailable()){
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: { (data: CMMotionActivity!) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(data.stationary == true){
                        self.activityState.text = "Stationary"
//                        self.stateImageView.image = UIImage(named: "Sitting")
                    } else if (data.walking == true){
                        self.activityState.text = "Walking"
//                        self.stateImageView.image = UIImage(named: "Walking")
                    } else if (data.running == true){
                        self.activityState.text = "Running"
//                        self.stateImageView.image = UIImage(named: "Running")
                    } else if (data.automotive == true){
                        self.activityState.text = "Automotive"
                    }
                })
                
            })
        }
        
        if(CMPedometer.isStepCountingAvailable()){
            let fromDate = NSDate(timeIntervalSinceNow: -86400 * 7)
            self.pedoMeter.queryPedometerData(from: fromDate as Date, to: NSDate() as Date) { (data : CMPedometerData!, error) -> Void in
                print(data)
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        self.steps.text = "\(data.numberOfSteps)"
                    }
                })
            }
            
            self.pedoMeter.startUpdates(from: midnightOfToday!) { (data: CMPedometerData!, error) -> Void in
                DispatchQueue.main.async(execute: { () -> Void in
                    if(error == nil){
                        self.steps.text = "\(data.numberOfSteps)"
                    }
                })
            }
        }
    }
}
