//
//  LoginResponse.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

//MARK:- RESPONSE OF SUCCESSFUL LOGIN SESSION

struct Auth : Codable{
     var account : Account
     var session : Session
}

struct Account: Codable {
     var registered : Bool
     var key : String
}

struct Session: Codable {
     var id : String
     var expiration : String
}
