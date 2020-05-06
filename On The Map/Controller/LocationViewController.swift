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
    @IBOutlet var locationTextView: UITextView!
    @IBOutlet var findOnMapButton: UIButton!
    @IBOutlet var questionStack: UIStackView!
    
    //MARK: Variables
    var location : CLLocation!
    
    
    //MARK:- View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()   /// Navigation Bar Setup
        self.navigationItem.setHidesBackButton(true, animated: true);   /// hide Back Button ( as we have cancel button)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        findOnMapButton.isEnabled = true
        hideKeyboardWhenTappedAround()
        locationTextView.centerVerticalText()       /// Cente text vertically in textview
    }
    

    
    //MARK:- IBActions
    @IBAction func findClicked(_ sender: UIButton) {
        findOnMapButton.isEnabled = false
        MapClient.TextToLocation(locationTextView.text, completion: handleTextToLocation(location:error:))
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
            vc.address = locationTextView.text
            vc.location = self.location
        }
    }
}



//MARK:- Extenion to handle landscape UI
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

//MARK:- UITextViewDelegate Methods
extension LocationViewController : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""      /// empty textfield when start typing
    }
}


// END
