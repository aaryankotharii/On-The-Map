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
    
    var postisExisting : Bool {
        if UserDefaults.standard.value(forKey: "objectId") == nil {
            return false
        }
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UdacityClient.getStudentInformation(completion: handleStudentInformation(data:error:))
    }
    
    
    @IBAction func logotuClicked(_ sender: Any) {
        FBLogin ?  handleFacebookLogout() : UdacityClient.logout(completion: handleLogout(success:error:))
        
    }
    
    @IBAction func postLocationClicked(_ sender: Any) {
        postisExisting ? overwriteAlert() : goToLocationVC()
    }
    @IBAction func refreshDataClicked(_ sender: Any) {
        UdacityClient.getStudentInformation(completion: handleStudentInformation(data:error:))
    }
    
    func handleStudentInformation(data: [StudentInformation],error:Error?){
        if let error = error{
            switch error.localizedDescription {
            case "The Internet connection appears to be offline.":
                networkErrorAlert(titlepass: error.localizedDescription)
            default:
                AuthAlert(error.localizedDescription, success: false)
            }
            return
            
        } else {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.data.results = data
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        }
    }
    
    func handleLogout(success:Bool,error:Error?){
        if success{
            UserDefaults.standard.setValue(false, forKey: "login")
            DispatchQueue.main.async {
                self.goToLoginVC()
            }
        }else{
            AuthAlert(error!.localizedDescription, success: false)
        }
    }
    
    func  handleFacebookLogout(){
        FacebookClient.logout()
        DispatchQueue.main.async {
            self.goToLoginVC()
        }
        
    }
    
    func goToLocationVC(){
        let vc = mainStoryboard.instantiateViewController(identifier: "LocationViewController") as LocationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToLoginVC(){
        let vc = mainStoryboard.instantiateViewController(identifier: "LoginVC") as LoginViewController
        self.present(vc, animated: true)
        
    }
}

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
