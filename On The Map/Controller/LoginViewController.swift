//
//  LoginViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginClicked(_ sender: UIButton) {
        
        //if errorCheck() != nil { print(errorCheck()!) ; return}
        
        UdacityClient.login(username: "z@k.com", password: "xoqrod-poxni8-xoQpug", completion: handleLogin(success:error:))
            }
    
    func handleLogin(success:Bool,error:Error?){
        if success{
            print("Logged in")
        }else{
            switch error?.localizedDescription {
            case "The data couldn’t be read because it isn’t in the correct format.":
                print("Wrong password")
            default:
                print(error?.localizedDescription)
            }
            print(error?.localizedDescription ?? "Error")
        }
    }
    
    func errorCheck() -> String? {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        if email.trimmed.isEmpty ||  password.trimmed.isEmpty {
            return "Please Fill in all the fields"
        }
        if !email.isEmail {
            return "Enter a valid email ID"
        }
        return nil
    }
}
