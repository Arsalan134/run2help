//
//  User.swift
//  run2help
//
//  Created by Arsalan Iravani on 28.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit
import SwiftyJSON

let currentUser = User()

class User: NSObject {
    
    // Private Info
    var id: String?
    var name: String?
    var lastname: String?
    var profileImage: UIImage?
    var profileImageURL: String?
    var email: String?
    var gender: String?
    var dateOfBirth: String?
    var height: Double?
    var weight: Double?
    
    // Activity Info
    var distance: Double?
    var numberOfSteps: Int?
    var caloriesBurned: Int?
    var donated: Double?
    var balance: Double?
    
    // Personal
    var personalDistance: Double?
    var personalNumberOfSteps: Int?
    var personalCaloriesBurned: Int?
    var personalMoneyDonated: Int?
    
    
    // Extra Info
    var location: String?
    var memberSince: String?
    var time: String?
    
    func setUser(json: JSON) {
        print("Setting User")
        
        
        guard let firstNameJson = json["first_name"].string else { fatalError(" Could not find name") }
        self.name = firstNameJson
        
        // LastName
        guard let lastNameJson = json["last_name"].string else { fatalError(" Could not find Last name") }
        self.lastname = lastNameJson
        
        // ID
        if let id = json["id"].string { self.id = "\(self.name ?? "")_\(self.lastname ?? "")_\(id)" }
        
        // Profile Image URL
        if let image = json["picture"].dictionary, let imageData = image["data"]?.dictionary {
            // Image
            //            if let profileImage = try? UIImage(data: Data(contentsOf: URL(string: url)!)){
            self.profileImageURL = imageData["url"]?.string
            //            }
            if let url = currentUser.profileImageURL {
                profileImage = try! UIImage(data: Data(contentsOf: URL(string: url)! ) )
            }
        }
        
        // Email
        if let email = json["email"].string { self.email = email }
        
        // Sex
        if let sex = json["gender"].string { self.gender = sex }
        
        // Date Of Birth
        if let dateOfBirth = json["birthday"].string { self.dateOfBirth = dateOfBirth }
        
        // Location
        guard let locationDictionary = json["location"].dictionary, let locationName = locationDictionary["name"]?.string else { return }
        self.location = locationName
        
        // load weight, height, distance, numberOfSteps, Caloriesburned, donated, member since , time
        
        print("Finished setting user")
        print("Self id: ", self.id ?? -1)
    }
    
    func resetUser() {
        self.name = nil
        self.lastname = nil
        self.email = nil
    }
    
    
}





