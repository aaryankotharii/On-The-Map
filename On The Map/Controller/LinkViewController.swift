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
    
    //MARK: Outlets
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var linkTextView: UITextView!
    @IBOutlet var webviewWidthAnchor: NSLayoutConstraint!
    
    //MARK: Variables
    var location : CLLocation!
    var address : String!
    
    //Check if user has an existing post
    var postisExisting : Bool {
        if UserDefaults.standard.value(forKey: "objectId") == nil {  return false   }
        return true
    }
    
    //MARK:- View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        setupCancelButton()     /// Add  cancel button to bar
        MapClient.setUpMap(location, mapView: mapView)      /// Setup Map
        hideKeyboardWhenTappedAround()          /// func name is explanotory
        linkTextView.centerVerticalText()       /// Centre align textview text vertically
    }
    
    
    //MARK:- Sumbit Clicked
    @IBAction func submitClicked(_ sender: UIButton) {
        // Data to be sent
        let student = NewStudentRequest(uniqueKey: "1234", firstName: "Aaryan", lastName: "Kothari", mapString: address, mediaURL: linkTextView.text, latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude))
        
        //Check for existing post
        if postisExisting{
            UdacityClient.updateStudentLocation(data: student, completion: handleUpdateStudentLocation)
        }else{
            UdacityClient.createNewStudentLocation(data: student, completion: handleCreateNewStudent(success:response:error:))
        }
    }
    
    //MARK:- Handle POST STUDENTLOCATION
    func handleCreateNewStudent(success:Bool,response:NewStudentResponse?,error:Error?){
        if success {
            let objectid = response?.objectId
            UserDefaults.standard.set(objectid, forKey: "objectId")
            successLAert("Your student Location successfully created")
        }
        else {  AuthAlert(error!.localizedDescription)  }
    }
    
    //MARK:- Handle PUT STUDENTLOCATION
    func handleUpdateStudentLocation(success:Bool,error:Error?){
        if success{     successLAert("Your student Location successfully updated")      }
        else {      AuthAlert(error!.localizedDescription)      }
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
    //***************************************************************//
    //MARK:- Animate IN webview if URL is valid
    func textViewDidEndEditing(_ textView: UITextView) {
        let width = view.frame.width / 2
        if let text = textView.text, let url = URL(string: text){
            
            if url.isValid{
                webviewWidthAnchor.constant = width
                showWebsite(url)
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
    //***************************************************************//

    
    //MARK: Empty TextView when start typing
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}


