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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        MapClient.setUpMap(location, mapView: mapView)
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitClicked(_ sender: UIButton) {
        let student = NewStudentRequest(uniqueKey: "1234", firstName: "Aaryan", lastName: "Kothari", mapString: address, mediaURL: "facebook.com", latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude))
        UdacityClient.createNewStudentLocation(data: student, completion: handleCreateNewStudent(success:error:))
    }
    
    func handleCreateNewStudent(success:Bool,error:Error?){
        if success {
            print("Success")
        } else {
            print(error?.localizedDescription)
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
        
        print("Success")
                
        webView.navigationDelegate = self
                        
        webView.load(URLRequest(url: url))
        
        webView.allowsBackForwardNavigationGestures = true
    }
}


//MARK:- UITextView Delegate Methods
extension LinkViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("Ended editing")
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

