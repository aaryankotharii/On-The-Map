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
}
