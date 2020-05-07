//
//  MapClient.swift
//  On The Map
//
//  Created by Aaryan Kothari on 05/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit

//MARK:- MAPCLIENT
class MapClient : NSObject, MKMapViewDelegate{
    
    var mapString = String()
    
    //MARK:- Convert text to location ( GEOCODING )
    class func TextToLocation(_ address : String, completion: @escaping (CLLocation?, Error?) -> Void){
        
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else {
                    completion(nil,error)
                    return
            }
            completion(location,nil)
        }
    }
    
    
    //MARK:- Convert location to Text ( REVERSE GEOCODING )
    class func locationToText(_ location: CLLocation,completion: @escaping (CLPlacemark)-> Void){
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {  return }
            guard let placemark = placemarks?.first else { return }
            completion(placemark)
        }
    }
    
    //MARK:- SET MAP
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
}

//END
