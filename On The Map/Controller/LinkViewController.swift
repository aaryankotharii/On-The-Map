//
//  LinkViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit
import WebKit

class LinkViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet var webView: WKWebView!
    
    @IBOutlet var linkTextView: UITextView!
    
    
    @IBOutlet var webviewWidthAnchor: NSLayoutConstraint!
    
    var location : CLLocation!
    var address : String!
    
    var postisExisting : Bool {
        if UserDefaults.standard.value(forKey: "objectId") == nil {
            return false
        }
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCancelButton()
        MapClient.setUpMap(location, mapView: mapView)
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        let student = NewStudentRequest(uniqueKey: "1234", firstName: "Aaryan", lastName: "Kothari", mapString: address, mediaURL: "facebook.com", latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude))
        if postisExisting{
            UdacityClient.updateStudentLocation(data: student, completion: handleUpdateStudentLocation)
        }else {
            UdacityClient.createNewStudentLocation(data: student, completion: handleCreateNewStudent(success:response:error:))
        }
    }

    
    func handleCreateNewStudent(success:Bool,response:NewStudentResponse?,error:Error?){
        if success {
            let objectid = response?.objectId
            UserDefaults.standard.set(objectid, forKey: "objectId")
            //TODO Success Alert
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            print(error?.localizedDescription)
        }
    }
    
    func handleUpdateStudentLocation(success:Bool,error:Error?){
        if success{
            //TODO Success Alert
            self.navigationController?.popToRootViewController(animated: true)
        }else {
            AuthAlert(error!.localizedDescription, success: false)
        }
    }
    

    
    //TODO
    //MARK: Check for Valid URL
    func urlChecker (_ urlString: String) -> Bool {
        if let url = NSURL(string: urlString) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}

//MARK:- WKNavigation Delegate Methods
extension LinkViewController: WKNavigationDelegate {
    func showWebsite(_ url : URL){
                        
        webView.navigationDelegate = self
                        
        webView.load(URLRequest(url: url))
        
        webView.allowsBackForwardNavigationGestures = true
    }
}


//MARK:- UITextView Delegate Methods
extension LinkViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let width = webView.frame.width
        if let text = textView.text{
     if urlChecker(text){
         webviewWidthAnchor.constant = width
        let url = URL(string: text)
        showWebsite(url!)
     }else{
         webviewWidthAnchor.constant = 0
     }
        UIView.animate(withDuration: 0.1,
                                delay: TimeInterval(0),
                                options: .curveEaseIn,
                                animations: { self.view.layoutIfNeeded() },
                                completion: nil)
    }
    }
    
    //MARK: Empty TextView when start typing
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}


