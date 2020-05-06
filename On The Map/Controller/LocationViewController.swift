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

    @IBOutlet var locationTextView: UITextView!
    @IBOutlet var findOnMapButton: UIButton!
    @IBOutlet var questionStack: UIStackView!
    
    var location : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        self.navigationItem.setHidesBackButton(true, animated: true);

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        findOnMapButton.isEnabled = true
        hideKeyboardWhenTappedAround()
    }
    

    

    @IBAction func findClicked(_ sender: UIButton) {
        findOnMapButton.isEnabled = false
        MapClient.TextToLocation(locationTextView.text, completion: handleTextToLocation(location:error:))
    }
    
    func handleTextToLocation(location : CLLocation?, error: Error?){
        if let error = error {
            let status = error.localizedDescription
            switch status {
            case "The operation couldn’t be completed. (kCLErrorDomain error 8.)":
                AuthAlert("Please Enter a Valid Location", success: false)
            case "The operation couldn’t be completed. (kCLErrorDomain error 2.)":
                networkErrorAlert(titlepass: "Internet required to locate given address")
            default:
                AuthAlert(status, success: false)
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
            vc.address = locationTextView.text
            vc.location = self.location
        }
    }
}


extension UIViewController{
    func setupNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }
    
    @objc func cancelTapped(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension LocationViewController{
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            questionStack.axis = .horizontal
            questionStack.spacing = 10

        } else {
            questionStack.axis = .vertical
            questionStack.spacing = 0
        }
    }
}

extension LocationViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}

