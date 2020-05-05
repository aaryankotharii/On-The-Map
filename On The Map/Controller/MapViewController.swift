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
    
    
    var studentData : StudentData {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.data
    }
    
    
    var annotations = [MKPointAnnotation]()

    
    
    override func viewDidLoad() {
        mapView.delegate = self
        super.viewDidLoad()
        SetupMap(studentData)
    }
    
    func SetupMap(_ data : StudentData){
    
        let studentDataArray = data.results
         for student in studentDataArray {
    
                 let lat = CLLocationDegrees(student.latitude)
                 let long = CLLocationDegrees(student.longitude)
    
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
    
                 let first = student.firstName
                 let last = student.lastName
                 let mediaURL = student.mediaURL
    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
             self.mapView.addAnnotations(annotations)
        }
    
    
}

extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
