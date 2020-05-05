//
//  LinkViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit

class LinkViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
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
    
    @IBAction func submitClicked(_ sender: UIButton) {
        let student = NewStudentRequest(uniqueKey: "1234", firstName: "Aaryan", lastName: "Kothari", mapString: address, mediaURL: "facebook.com", latitude: Double(location.coordinate.latitude), longitude: Double(location.coordinate.longitude))
        UdacityClient.createNewStudentLocation(data: student) { (success, error) in
            print(success,error)
        }
    }
    
}
