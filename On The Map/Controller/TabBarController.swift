//
//  TabBarController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
        
    
    var idk = "HELLLOOOOO"

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        UdacityClient.getStudentInformation(completion: handleStudentInformation(data:error:))
        // Do any additional setup after loading the view.
    }
    

    @IBAction func logotuClicked(_ sender: Any) {
        UdacityClient.logout {
                    UserDefaults.standard.setValue(false, forKey: "login")
        }
    }

    @IBAction func postLocationClicked(_ sender: Any) {
        print("Post")
        goToLocationVC()
    }
    @IBAction func refreshDataClicked(_ sender: Any) {
        print("Refresh")
        UdacityClient.getStudentInformation(completion: handleStudentInformation(data:error:))
    }
    
    func handleStudentInformation(data: [StudentInformation],error:Error?){
        if let error = error{
            print(error.localizedDescription)
            return
        } else {
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.data.results = data
        }
    }
    
    func goToLocationVC(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "LocationViewController") as LocationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
