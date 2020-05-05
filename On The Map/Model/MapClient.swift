//
//  MapClient.swift
//  On The Map
//
//  Created by Aaryan Kothari on 05/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit

class MapClient : NSObject, MKMapViewDelegate{
    
    var mapString = String()
    
    class func TextToLocation(_ address : String, completion: @escaping (CLLocation?, Error?) -> Void){
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                completion(nil,error)
                return
            }
          completion(location,nil)
        }
    }
    
    class func locationToText(_ location: CLLocation,completion: @escaping (CLPlacemark)-> Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if let _ = error {  return }
        guard let placemark = placemarks?.first else { return }
        completion(placemark)
        }
    }
    
    class func setUpMap(_ location: CLLocation, mapView: MKMapView){
        // Define a region for our map view
        var mapRegion = MKCoordinateRegion()

        let mapRegionSpan = 0.3
        mapRegion.center = location.coordinate
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan

        mapView.setRegion(mapRegion, animated: true)
        
        locationToText(location) { (placemark) in
                 let streetName = placemark.thoroughfare ?? ""
               let cityState  = "\(placemark.locality ?? ""),\(placemark.administrativeArea ?? "")"

               // Create a map annotation
               let annotation = MKPointAnnotation()
               annotation.coordinate = location.coordinate
               annotation.title = cityState
               annotation.subtitle = "\(streetName), \(cityState)"

               mapView.addAnnotation(annotation)
        }
    }
    

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
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
