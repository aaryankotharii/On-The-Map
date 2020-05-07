//
//  LocationViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var findOnMapButton: UIButton!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var UrlTextField: UITextField!
    
    //MARK: Variables
    var location : CLLocation!
    
    
    //MARK:- View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()   /// Navigation Bar Setup
        self.navigationItem.setHidesBackButton(true, animated: true);   /// hide Back Button ( as we have cancel button)
        self.navigationItem.title = "Add Location"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        findOnMapButton.isEnabled = true
        hideKeyboardWhenTappedAround()
    }
    

    
    //MARK:- IBActions
    @IBAction func findClicked(_ sender: UIButton) {
        findOnMapButton.isEnabled = false
        MapClient.TextToLocation(locationTextField.text!, completion: handleTextToLocation(location:error:))
    }
    
    func errorCheck()->String?{
        return nil
    }
    
    //MARK:- Text to location handler
    func handleTextToLocation(location : CLLocation?, error: Error?){
        if let error = error {
            let status = error.localizedDescription
            switch status {
            case "The operation couldn’t be completed. (kCLErrorDomain error 8.)":
                AuthAlert("Please Enter a Valid Location")
            case "The operation couldn’t be completed. (kCLErrorDomain error 2.)":
                networkErrorAlert(titlepass: "Internet required to locate given address")
            default:
                AuthAlert(status)
            }
            findOnMapButton.isEnabled = true
            return
        }
        self.location = location
        performSegue(withIdentifier: "tolinkvc", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "tolinkvc" {
            let vc = segue.destination as! LinkViewController
            vc.address = locationTextField.text
            vc.location = self.location
            vc.mediaUrl = UrlTextField.text
        }
    }
}

//MARK:- UITextViewDelegate Methods
extension LocationViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""     /// Empty textfield when strt typing
    }
}


// END
