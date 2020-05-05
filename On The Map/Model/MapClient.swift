//
//  MapClient.swift
//  On The Map
//
//  Created by Aaryan Kothari on 05/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import UIKit
import MapKit

class MapClient{
    
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
    
    private func locationToText(_ location: CLLocation) -> CLPlacemark?{
        let geoCoder = CLGeocoder()
        var address = CLPlacemark()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
        if let _ = error {  return }
        guard let placemark = placemarks?.first else { return }
        address = placemark
        }
        return address
    }
    
    class func setUpMap(_ location: CLLocation, mapView: MKMapView){
        // Define a region for our map view
        var mapRegion = MKCoordinateRegion()

        let mapRegionSpan = 0.3
        mapRegion.center = location.coordinate
        mapRegion.span.latitudeDelta = mapRegionSpan
        mapRegion.span.longitudeDelta = mapRegionSpan

        mapView.setRegion(mapRegion, animated: true)

        // Create a map annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = "Apple Inc."
        annotation.subtitle = "One Apple Park Way, Cupertino, California."

        mapView.addAnnotation(annotation)
    }
}
