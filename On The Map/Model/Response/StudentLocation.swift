//
//  StudentInformation.swift
//  On The Map
//
//  Created by Aaryan Kothari on 03/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {

    let createdAt : String
    let firstName : String
    let lastName: String
    let latitude : Double
    let longitude : Double
    let mapString : String
    let mediaURL : String
    let objectId : String
    let uniqueKey : String
    let updatedAt : String
}


struct StudentData : Codable {
    let results = [StudentInformation]()
}
