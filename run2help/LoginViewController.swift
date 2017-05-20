
//
//  LogInViewController.swift
//  run2help
//
//  Created by Arsalan Iravani on 28.03.17.
//  Copyright © 2017 Arsalan Iravani. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var loginSuccess = false
    
    @IBOutlet weak var logoutFacebookButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FBSDKAccessToken.current() != nil {
            print("Token is not nil")
            logoutFacebookButton.isHidden = false
            FacebookManager.getUserData(completion: {
                self.loginFacebookButton.setTitle("Contininue as \(currentUser.name ?? "Next")", for: .normal)
            })
            // self.loginSuccess = true
            // self.viewDidAppear(true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && loginSuccess) {
            performSegue(withIdentifier: "MainView", sender: self)
        }
    }
    
    // Login
    @IBAction func facebookLogin(_ sender: UIButton) {
        if FBSDKAccessToken.current() != nil {
            self.loginSuccess = true
            self.viewDidAppear(true)
        } else {
            print("\n\nTOKEN IS NIL\n\n")
            
            // Open safari and login
            FacebookManager.shared.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (result, error) in
                if error == nil {
                    FacebookManager.getUserData(completion: {
                        
                        handleRegister()
                        
                        self.loginSuccess = true
                        self.viewDidAppear(true)
                        
                    })
                }
            })
            
            //            let userC = User.currentUser
            //
            //            let values: [String : Any] = ["name": userC.name ?? "no name", "lastname": userC.lastname ?? "no lastname", "email": userC.email ?? "no email", "caloriesBurned": userC.caloriesBurned ?? -2, "dateOfBirth": userC.dateOfBirth ?? "no date yet", "distance": userC.distance ?? -2, "donated": userC.donated ?? -2, "height": userC.height ?? -23, "location": userC.location ?? "no location yet", "memberSince": userC.memberSince ?? "no date yet", "numberOfSteps": userC.numberOfSteps ?? -34, "sex": userC.sex ?? "kisi", "time": userC.time ?? "no time yet", "weight": userC.weight ?? -923]
            //
            
            //            registerUserInToDatabase(withID: FIRAuth.auth()?.currentUser?.uid, values: values)
            
//            self.loginSuccess = true
//            self.viewDidAppear(true)
        }
    }
    
    
    
    // Login Facebook
    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    //    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    //        if error != nil {
    //            print(error)
    //            return
    //        }
    //
    //        handleRegister()
    //        self.loginSuccess = true
    //        self.viewDidAppear(true)
    //    }
    
    // Logout Facebook
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out from facebook")
    }
    
    // Logout
    @IBAction func facebookLogout(_ sender: UIButton) {
        FacebookManager.shared.logOut()
        currentUser.resetUser()
        logoutFacebookButton.isHidden = true
        loginFacebookButton.setTitle("Login with Facebook", for: .normal)
    }
    
}



