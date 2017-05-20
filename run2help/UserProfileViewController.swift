//
//  UserProfileViewController.swift
//  run2help
//
//  Created by Arsalan Iravani on 28.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userMemberSinceLabel: UILabel!
    @IBOutlet weak var donatedLabel: UILabel!
    
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var moneyDonatedLabel: UILabel!
    @IBOutlet weak var caloriesBurnedLabel: UILabel!
    
    @IBOutlet weak var personalDistanceLabel: UILabel!
    @IBOutlet weak var personalMoneyDonatedLabel: UILabel!
    @IBOutlet weak var personalCaloriesBurnedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userImage.layer.cornerRadius = userImage.layer.bounds.size.width / 2.0
        
        if let nameOptional = currentUser.name, let lastNameOptional = currentUser.lastname {
            userFullNameLabel.text = "\(nameOptional) \(lastNameOptional)"
        }
        
        if let profileImageOptional = currentUser.profileImage {
            userImage.image = profileImageOptional
        }
        fetchUserData()
    }
    
    func fetchUserData() {
        userLocationLabel.text = "\(currentUser.location ?? "not available")"
        userMemberSinceLabel.text = "Member since: \(currentUser.memberSince ?? "no Value")"
        donatedLabel.text = "Donated: \(currentUser.donated ?? -1) AZN"
        distanceLabel.text = "\(currentUser.distance ?? -1)km = \(currentUser.numberOfSteps ?? -123) steps"
        moneyDonatedLabel.text = "\(currentUser.donated ?? -1) AZN"
        caloriesBurnedLabel.text = "\(currentUser.caloriesBurned ?? -1) cal"
        
        personalDistanceLabel.text = "\(currentUser.personalDistance ?? -1)km = \(currentUser.personalNumberOfSteps ?? -1) steps"
        personalMoneyDonatedLabel.text = "\(currentUser.personalMoneyDonated ?? -1)"
        personalCaloriesBurnedLabel.text = "\(currentUser.personalCaloriesBurned ?? -1)"
        
        
        
        //        let RFC3339DateFormatter = DateFormatter()
        //        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //        RFC3339DateFormatter.dateFormat = "dd MM yyyy"
        //        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        
        //        /* 39 minutes and 57 seconds after the 16th hour of December 19th, 1996 with an offset of -08:00 from UTC (Pacific Standard Time) */
        //        let string = "1996-12-19T16:39:57-08:00"
        //        //                let string = "24 March 2017'T'"
        //        let date = RFC3339DateFormatter.date(from: string)
        //
        //        //format in which recived Date Present
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd-MMM-yyyy"
        //        let newDate = dateFormatter.date(from: "20-MAR-2017")
        //        // format to which you need your date to convert
        //        dateFormatter.dateFormat = "MMM-dd-yyyy"
        //        if let newDate  = newDate {
        //            let dateStr = dateFormatter.string(from: newDate)
        //            print(dateStr) //Output: MAR-20-2017
        //        }
        
        
        //        todayDateLabel.text = "Today: \(String(describing: date))"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showHistoryOfDonations(_ sender: UIButton) {
        print("Show history of donations")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
