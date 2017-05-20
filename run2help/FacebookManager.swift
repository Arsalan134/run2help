//
//  FacebookManager.swift
//  run2help
//
//  Created by Arsalan Iravani on 03.04.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import SwiftyJSON

class FacebookManager {
    static let shared = FBSDKLoginManager()
    
    public class func getUserData(completion: @escaping () -> Void) {
        
        print("get user data from FACEBOOK MANAGER")
        
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, email, picture.type(large), gender, age_range, locale, location, birthday"]).start(completionHandler: { (connection, result, error) in
                if error == nil {
                    if let resultOptional = result {
                        let json = JSON(resultOptional)
                        print(json)
                        currentUser.setUser(json: json)
                        downloadUserFromDatabase()
                        completion()
                    }
                }
            })
        }
    }
}

