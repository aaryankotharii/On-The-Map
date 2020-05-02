//
//  LoginRequest.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

struct Udacity:Codable {
    let udacity:User
}

// struct to store the login credentials for request
struct User:Codable {
    
    let username:String
    let password:String
}
