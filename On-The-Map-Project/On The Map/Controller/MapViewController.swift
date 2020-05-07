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
    
    //MARK:- StudentLocation Data
    var data = (UIApplication.shared.delegate as! AppDelegate).data.results
    
    //MARK: View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        AddObserver()   /// ADD OBSERVER
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perform(#selector(loadList), with: nil, afterDelay: 2.0)
    }
    
    func AddObserver(){
        let selector =  #selector(loadList)
        let name = NSNotification.Name(rawValue: "load")
        NotificationCenter.default.addObserver(self, selector:selector, name: name , object: nil)
    }
    
    @objc func loadList(){
        reloadData()
    }
    
    func SetupMap(_ data : [StudentInformation]){
        self.mapView.removeAnnotations(self.mapView.annotations)
        for student in data {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // extracting data from struct
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Create annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Add annotations to mapView
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //MARK:- RELOAD
    func reloadData(){
        data = (UIApplication.shared.delegate as! AppDelegate).data.results
        SetupMap(data)
    }
}


//MARK:- MapView Delegate Methods
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
    
    //MARK:- Tapped Annotaion GOTO SF SafariView
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let mediaUrl = ((view.annotation?.subtitle) ?? "") ?? ""
            presentSafari(mediaUrl)
        }
    }
}
//END
