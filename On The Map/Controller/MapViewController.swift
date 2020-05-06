//
//  MapViewController.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    //MARK:- StudentLocation Data
    var data = (UIApplication.shared.delegate as! AppDelegate).data.results
    
    //MARK: View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        AddObserver()   /// ADD OBSERVER
        //reloadData()    //// ADD PINS
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
            
            let first = student.firstName
            let last = student.lastName
            let mediaURL = student.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            self.mapView.addAnnotation(annotation)
        }
    }
    
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
            if let url = URL(string: mediaUrl) {
                if url.isValid{ /// Check Valid URL
                    let vc = SFSafariViewController(url: url)
                    present(vc, animated: true) /// Present safariVC
                }else{
                    AuthAlert("The User did not sumbit a valid URL. Try another one maybe?", success: false)
                }
            }
        }
    }
}


//END
