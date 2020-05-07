//
//  TabBarController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import Network

class TabBarController: UITabBarController {
    
    let limit = 100
    let order = "-updatedAt"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UdacityClient.getStudentInformation(limit: limit, order: order,completion: handleStudentInformation(data:error:))
    }
    
    //MARK:- IBACTIONS
    @IBAction func logotuClicked(_ sender: Any) {
        FBLogin ?  handleFacebookLogout() :  UdacityClient.getStudentInformation(limit: limit, order: order,completion: handleStudentInformation(data:error:))
    }
    
    @IBAction func postLocationClicked(_ sender: Any) {
        postisExisting ? overwriteAlert() : goToLocationVC()
    }
    @IBAction func refreshDataClicked(_ sender: Any) {
        UdacityClient.getStudentInformation(completion: handleStudentInformation(data:error:))
    }
    
    
    //MARK: Handle Student information fetching
    func handleStudentInformation(data: [StudentInformation],error:Error?){
        if let error = error{
            switch error.localizedDescription {
            case "The Internet connection appears to be offline.":
                networkErrorAlert(titlepass: error.localizedDescription)
            default:
                AuthAlert(error.localizedDescription)
            }
            return
            
        } else {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.data.results = data
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
    
    
    //MARK:- Logout handlers
    func handleLogout(success:Bool,error:Error?){
        if success{
            UserDefaults.standard.setValue(false, forKey: "login")
            DispatchQueue.main.async { self.goToLoginVC() }
        }
        else{
            AuthAlert(error!.localizedDescription)
        }
    }
    
    func  handleFacebookLogout(){
        FacebookClient.logout()
        DispatchQueue.main.async {
            self.goToLoginVC()
        }
    }
    
    
    //MARK:- Functions for navigating to new VC
    func goToLocationVC(){
        let vc = mainStoryboard.instantiateViewController(identifier: "LocationViewController") as LocationViewController
        self.navigationController?.pushViewController(vc, animated: true)   /// FOR PIN CLICK
    }
    
    func goToLoginVC(){
        let vc = mainStoryboard.instantiateViewController(identifier: "LoginVC") as LoginViewController
        self.present(vc, animated: true)    /// FOR LOGOUT
    }
}


//MARK:- TabBarController Alert Functions
extension TabBarController {
    func overwriteAlert(){
        let alert = UIAlertController(title: nil, message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: .alert)
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .default, handler: handleOverwriteClicked(action:))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(overwriteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func handleOverwriteClicked(action :  UIAlertAction){
        goToLocationVC()
    }
}

// END
