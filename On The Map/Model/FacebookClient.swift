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


extension LoginViewController {
        
     func fbLogin(completion: @escaping (Bool, Error?) -> Void){
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { (loginResult) in
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
}
