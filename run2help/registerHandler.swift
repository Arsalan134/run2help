//
//  registerHandler.swift
//  run2help
//
//  Created by Arsalan Iravani on 10.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation
import Firebase
import FBSDKLoginKit

func handleRegister() {
    
    let accessToken = FBSDKAccessToken.current()
    guard let accessTokenString = accessToken?.tokenString else { return }
    let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
    
    FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
        if error != nil {
            print(error ?? " Some thing went wrong")
            return
        }
    })
    
    print("Seccessfully logged in")
    
    let values: [String : Any] = [
        "name": currentUser.name ?? "no name",
        "lastname": currentUser.lastname ?? "no lastname",
        "email": currentUser.email ?? "no email",
        "caloriesBurned": currentUser.caloriesBurned ?? 0,
        "dateOfBirth": currentUser.dateOfBirth ?? "no date yet",
        "distance": currentUser.distance ?? 0,
        "donated": currentUser.donated ?? 0,
        "balance": currentUser.balance ?? 0,
        "height": currentUser.height ?? 0,
        "location": currentUser.location ?? "no location yet",
        "memberSince": currentUser.memberSince ?? "no date yet",
        "numberOfSteps": currentUser.numberOfSteps ?? 0,
        "gender": currentUser.gender ?? "kisi",
        "time": currentUser.time ?? "no time yet",
        "weight": currentUser.weight ?? 0,
        
        "personalDistance": currentUser.personalDistance ?? 0,
        "personalNumberOfSteps": currentUser.personalNumberOfSteps ?? 0,
        "personalMoneyDonated": currentUser.personalMoneyDonated ?? 0,
        "personalCaloriesBurned": currentUser.personalCaloriesBurned ?? 0
    ]
    
    registerUserInToDatabase(withID: currentUser.id, values: values as [String : Any])
}

private func registerUserInToDatabase(withID id: String?, values: [String: Any]) {
    let ref = FIRDatabase.database().reference(fromURL: "https://run2help-a881d.firebaseio.com/")
    guard let uid = id else { return }
    let userReference = ref.child("Users").child(uid)                     // creates unique id for each user
    
    //  included user in database
    userReference.updateChildValues(values, withCompletionBlock: {
        (err, ref) in
        if err != nil {
            print(err ?? "error")
        }
        
        currentUser.name = values["name"] as? String
        currentUser.lastname = values["lastname"] as? String
        currentUser.profileImageURL = values["imageURL"] as? String
        currentUser.email = values["email"] as? String
        currentUser.gender = values["gender"] as? String
        currentUser.dateOfBirth = values["dateOfBirth"] as? String
        
        currentUser.height = values["height"] as? Double
        currentUser.weight = values["weight"] as? Double
    
        currentUser.distance = values["distance"] as? Double
        currentUser.numberOfSteps = values["numberOfSteps"] as? Int
        currentUser.caloriesBurned = values["caloriesBurned"] as? Int
        
        currentUser.donated = values["donated"] as? Double
        
        currentUser.location = values["location"] as? String
        currentUser.memberSince = values["memberSince"] as? String
        currentUser.time = values["time"] as? String
        
        currentUser.personalDistance = values["personalDistance"] as? Double
        currentUser.personalNumberOfSteps = values["personalNumberOfSteps"] as? Int
        currentUser.personalMoneyDonated = values["personalMoneyDonated"] as? Int
        currentUser.personalCaloriesBurned = values["personalCaloriesBurned"] as? Int
    
        // succesfully included user in database
        print("Saved user seccessfully into Firebase db")
        print(currentUser)
    })
}


























