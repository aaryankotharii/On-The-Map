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
    
    @IBOutlet var stackYanchor: NSLayoutConstraint!
    
    var keyboardUp : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //INITIAL SETUP
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications() /// REMOVE OBSERVERS
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        UdacityClient.login(username: "z@k.com", password: "xoqrod-poxni8-xoQpug", completion: handleLogin(success:error:))
    }
    
    @IBAction func fbLoginClicked(_ sender: UIButton) {
        FacebookClient.fbLogin(vc: self, completion: handleFacebookLogin(success:error:))
    }
    
    
    func handleLogin(success:Bool,error:Error?){
        if success{
            successLogin()
            print("Logged in")
        }else{
            if errorCheck() != nil { AuthAlert(errorCheck()!) ; return }
            AuthAlert(error?.localizedDescription ??  "Error")
        }
    }
    
    func handleFacebookLogin(success:Bool,error:Error?){
        if success{
            successLogin()
             FacebookClient.getUserData(completion: handleFacebookData(success:data:error:))
        }else{
            AuthAlert(error?.localizedDescription ??  "Error")
        }
    }
    
    func successLogin(){
        UIDevice.validVibrate()
        goToTabBar()
        UserDefaults.standard.setValue(true, forKey: "login")
    }
    
    func handleFacebookData(success:Bool,data:fbData,error:Error?){
        if success {
            print(data)
        }else{
            print(error?.localizedDescription)
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
    
    
    func goToTabBar(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "nav") as! UINavigationController
        self.present(vc, animated: true)
    }
}


//MARK:- Keyboard show + hide functions
extension LoginViewController {
    
    //MARK: Add Observers
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: Remove Observers
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //MARK: Move stackView based on keybaord
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            
            //MARK: Get Keboard Y point on screen
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            
            //MARK: Get keyboard display time
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            
            //MARK: Set animations
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            //MARK: Animate stackView
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.stackYanchor.constant = 0.0
            } else {
                self.stackYanchor.constant = -35
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
}

