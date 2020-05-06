//
//  FacebookClient.swift
//  On The Map
//
//  Created by Aaryan Kothari on 05/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit


class FacebookClient {
        
    class func fbLogin(vc : UIViewController,completion: @escaping (Bool, Error?) -> Void){
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: vc) { (loginResult) in
            switch loginResult{
            case .cancelled:
                print("User cancelled login process.")
                completion(false, nil)
            case .failed(let error):
                print(error.localizedDescription)
                completion(false, error)
            case .success( _, _, _):
                print("Logged In")
                completion(true, nil)
            }
        }
    }
    
    class func getUserData(completion: @escaping (Bool, fbData ,Error?) -> Void){
        if((AccessToken.current) != nil){
                  GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        completion(false,fbData(),error)
                        return
                    }
                          
                          let dict = result as! [String : AnyObject]
                          let picutreDic = dict as NSDictionary
                          
                          let name = picutreDic.object(forKey: "name") as! String
                          let emailAddress = picutreDic.object(forKey: "email") as! String
                   
                    completion(true,fbData(name: name, email: emailAddress), nil)
                  })
              }
          }
    
    class func logout(){
        let loginManager = LoginManager()
        loginManager.logOut()
    }
    }

struct fbData{
    var name : String = ""
    var email : String = ""
}

