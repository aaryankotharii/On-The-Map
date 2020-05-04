//
//  ViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit

class loginPageViewController: UIViewController{
    
    var emailID : String = ""
    var name : String = "abcd"
    
    var hello = "hello"
    
    
     
    @IBOutlet var push: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         name  = "viewDidLoad"

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginFbTapped(_ sender: UIButton){
        fbLogin()
         name = "fbTapped"
    }

    
    //MARK:- Facebook Login
    func fbLogin() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions:[ .publicProfile, .email], viewController: self) { loginResult in
            
            switch loginResult {
            
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login process.")
            case .success( _, _, _):
                print("Logged in!")
                self.getFBUserData()
        
            }
        }
    }
    
  //Mark:- Get Data
    func getFBUserData() {
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! [String : AnyObject]
                    let picutreDic = dict as NSDictionary
                    
                    self.name = picutreDic.object(forKey: "name") as! String
                    self.nameLabel.text = "Name:- " + self.name
                    print("name:- ",self.name)
                    
                    let emailAddress = picutreDic.object(forKey: "email")
                    self.emailID = emailAddress as! String
                    self.emailLabel.text = "Email ID:- " + self.emailID
                    print("email:- ",self.emailID)
                }
                print(error?.localizedDescription as Any)
            })
        }
    }
}
