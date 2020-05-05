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
    
    
    var location : CLLocation!
    var address : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        MapClient.setUpMap(location, mapView: mapView)
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showWebsite(URL(string: "https://www.google.com")!)
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
