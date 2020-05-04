//
//  LocationViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    @IBOutlet var locationTextView: UITextView!
    
    @IBOutlet var findOnMapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }
    
    @objc func cancelTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    

    @IBAction func findClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "tolinkvc", sender: locationTextView.text)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "tolinkvc" {
                   let vc = segue.destination as! LinkViewController
            vc.location = sender as? String
            }
    }
}
