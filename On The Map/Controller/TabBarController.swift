//
//  TabBarController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logotuClicked(_ sender: Any) {
        UdacityClient.logout {
                    UserDefaults.standard.setValue(false, forKey: "login")

        }
    }

    @IBAction func postLocationClicked(_ sender: Any) {
        print("Post")
    }
    @IBAction func refreshDataClicked(_ sender: Any) {
        print("Refresh")
    }
    
}
