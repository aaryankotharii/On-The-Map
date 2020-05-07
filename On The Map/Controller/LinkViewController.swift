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
    
    //MARK: Variables
    var location : CLLocation!
    var address : String!
    var mediaUrl : String!
    
    //MARK:- View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup(){
        setupNavBar()     /// Add  cancel button to bar + Custom Back buttom
        MapClient.setUpMap(location, mapView: mapView)      /// Setup Map
        hideKeyboardWhenTappedAround()          /// func name is explanotory
    }
    
    
    //MARK:- Sumbit Clicked
    @IBAction func submitClicked(_ sender: UIButton) {
        // Data to be sent
        let student = NewStudentRequest(uniqueKey: "1234", firstName: "Aaryan", lastName: "Kothari", mapString: address, mediaURL: mediaUrl, latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude))
        
        //Check for existing post and goForward
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
//extension LinkViewController: WKNavigationDelegate {
//    func showWebsite(_ url : URL){
//
//        webView.navigationDelegate = self
//
//        webView.load(URLRequest(url: url))
//
//        webView.allowsBackForwardNavigationGestures = true
//    }
//}


//MARK:- UITextView Delegate Methods
extension LinkViewController: UITextViewDelegate {
    //***************************************************************//
    //MARK:- Animate IN webview if URL is valid
//    func textViewDidEndEditing(_ textView: UITextView) {
//        let width = view.frame.width / 2
//        let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
//        if let url = URL(string: text){
//
//            if url.isValid{
//                webviewWidthAnchor.constant = width
//                showWebsite(url)
//            }else{
//                webviewWidthAnchor.constant = 0
//            }
//            UIView.animate(withDuration: 0.1,
//                           delay: TimeInterval(0),
//                           options: .curveEaseIn,
//                           animations: { self.view.layoutIfNeeded() },
//                           completion: nil)
//        }
//    }
    //***************************************************************//
}


