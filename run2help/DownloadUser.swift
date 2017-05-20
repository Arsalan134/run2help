//
//  DownloadUser.swift
//  run2help
//
//  Created by Arsalan Iravani on 16.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation
import Firebase

func downloadUserFromDatabase() {
    print("Start Download User From Database")
    guard let uid = currentUser.id else {
        print("Ouch")
        return
    }
    
    FIRDatabase.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
        if let dictionary = snapshot.value as? [String: Any] {
            
            currentUser.email = dictionary["email"] as? String
            currentUser.gender = dictionary["gender"] as? String
            currentUser.dateOfBirth = dictionary["dateOfBirth"] as? String
            currentUser.weight = dictionary["weight"] as? Double
            currentUser.height = dictionary["heighat"] as? Double
            
            currentUser.distance = dictionary["distance"] as? Double
            currentUser.numberOfSteps = dictionary["numberOfSteps"] as? Int
            currentUser.caloriesBurned = dictionary["caloriesBurned"] as? Int
            currentUser.donated = dictionary["donated"] as? Double
            currentUser.balance = dictionary["balance"] as? Double
            
            currentUser.location = dictionary["location"] as? String
            currentUser.memberSince = dictionary["memberSince"] as? String
            currentUser.time = dictionary["time"] as? String
            
            currentUser.personalDistance = dictionary["personalDistance"] as? Double
            currentUser.personalNumberOfSteps = dictionary["personalNumberOfSteps"] as? Int
            currentUser.personalMoneyDonated = dictionary["personalMoneyDonated"] as? Int
            currentUser.personalCaloriesBurned = dictionary["personalCaloriesBurned"] as? Int
            print("Ended!")
        }
    })
}




