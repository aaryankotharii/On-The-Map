//
//  NewStudentResponseResponse.swift
//  On The Map
//
//  Created by Aaryan Kothari on 04/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

//MARK:- RESPONSE OF SUCCESSFUL STUDENT CREATION

struct NewStudentResponse : Codable{
     var objectId : String
     var createdAt : String
}

struct updtatedStudentResponse : Codable {
    var updatedAt : String
}
