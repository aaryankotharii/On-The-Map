//
//  LoginViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import Network

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var stackYanchor: NSLayoutConstraint!     /// VStack Vertical Position Anchor wrt screen center
    
    
    //MARK: Variables
    var keyboardUp : Bool = false
    
    
    //MARK:- View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        UserDefaults.standard.set(nil, forKey: "objectId")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()  /// ADD OBSERVERS
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications() /// REMOVE OBSERVERS
    }
    
    //MARK:- Button Action Methods
    @IBAction func loginClicked(_ sender: UIButton) {
        //TODO error check
        UdacityClient.login(username: "z@k.com", password: "xoqrod-poxni8-xoQpug", completion: handleLogin(success:error:))
    }
    
    @IBAction func fbLoginClicked(_ sender: UIButton) {
        FacebookClient.fbLogin(vc: self, completion: handleFacebookLogin(success:error:))
    }
    
    
    //MARK:- Completion handler methods
    func handleLogin(success:Bool,error:Error?){
        if success{
            successLogin()
            debugLog(message: "Logged In Successfully")
        }else{
            if error != nil { AuthAlert(error!.localizedDescription, success: false) ; return }
        }
    }
    
    func handleFacebookLogin(success:Bool,error:Error?){
        if success{
            successLogin()
            FacebookClient.getUserData(completion: handleFacebookData(success:data:error:))
        }else{
            AuthAlert(error?.localizedDescription ??  "Error", success: false)
        }
    }
    
    func handleFacebookData(success:Bool,data:fbData,error:Error?){
        if success {
            print(data)
        }else{
            print(error?.localizedDescription)
        }
    }
    
    func successLogin(){
        UIDevice.validVibrate()
        goToTabBar()
        UserDefaults.standard.setValue(true, forKey: "login")
    }
    
    
    //MARK:- Error Checking Function
    func errorCheck() -> String? {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if email == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please Fill in all the fields"
        }
        if !(email?.isEmail ?? true) {
            return "entered Email ID is invalid"
        }
        return nil
    }
    
    
    func goToTabBar(){
        let vc = mainStoryboard.instantiateViewController(identifier: "nav") as! UINavigationController
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



//    let monitor = NWPathMonitor()
//monitor.pathUpdateHandler = { path in
//         if path.status == .satisfied {
//             print("We're connected!")
//         } else {
//             print("No connection.")
//             self.networkErrorAlert(titlepass: "Helllo")
//         }
//
//         print(path.isExpensive)
//     }
//
//     let queue = DispatchQueue(label: "Monitor")
//     monitor.start(queue: queue)
