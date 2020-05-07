//
//  StudentLocationRequest.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

//Struct to send data for ne student location
struct NewStudentRequest: Codable {
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double
    let longitude : Double
}
