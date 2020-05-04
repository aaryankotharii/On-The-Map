//
//  MapViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var studentData = [StudentLocation]()
    var annotations = [MKPointAnnotation]()


    override func viewDidLoad() {
        
        mapView.delegate = self
        super.viewDidLoad()
      //  UdacityClient.getStudentLocation(completion: handleStudentData(studentData:error:))
    }
    
}

extension MapViewController: MKMapViewDelegate{
    
}
