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
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    

    
    //MARK:- IBActions
    @IBAction func findClicked(_ sender: UIButton) {
        findOnMapButton.isEnabled = false
        if let error = errorCheck() {AuthAlert(error);  return}
        MapClient.TextToLocation(locationTextField.text!, completion: handleTextToLocation(location:error:))
    }
    
    func errorCheck()->String?{
        if UrlTextField.text == "" {
            return "Please enter a URL"
        }
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

//MARK:- Keyboard show + hide functions
extension LocationViewController {
    
    //MARK: Add Observers
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Remove Observers
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Move view up /down only for bottomTextField
    @objc func keyboardWillShow(_ notification:Notification) {
        if UrlTextField.isFirstResponder {
            view.frame.origin.y -= 30
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if UrlTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    // Get the height of keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        let height = keyboardSize.cgRectValue.height // Height of Keyboard
        return height
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            subscribeToKeyboardNotifications()
        } else {
            print("Portrait")
            unsubscribeFromKeyboardNotifications()
        }
    }
}


// END
