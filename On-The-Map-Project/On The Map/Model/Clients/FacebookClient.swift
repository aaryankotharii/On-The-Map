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

//MARK:- ALL FACEBOOK RELATED FUNCTIONS
class FacebookClient {
    
    //FACEBOOK LOGIN
    class func fbLogin(vc : UIViewController,completion: @escaping (Bool, Error?) -> Void){
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: vc) { (loginResult) in
            switch loginResult{
            case .cancelled:
                debugLog(message: "User cancelled login process.")
                completion(false, nil)
            case .failed(let error):
                debugLog(message: error.localizedDescription)
                completion(false, error)
            case .success( _, _, _):
                debugLog(message: "FB Login Successful")
                completion(true, nil)
            }
        }
    }
    
    
    //GET DATA ( NAME + EMAIL + ETC )
    class func getUserData(completion: @escaping (Bool, fbData ,Error?) -> Void){
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, picture.type(large), email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
                
                if let error = error {
                    print(error.localizedDescription)       /// Not using Data since Udacity GETting data not wokring
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
    
    //LOGOUT
    class func logout(){
        let loginManager = LoginManager()
        loginManager.logOut()
    }
}


//MARK:- Struct to get data
struct fbData{
    var name : String = ""
    var email : String = ""
}

