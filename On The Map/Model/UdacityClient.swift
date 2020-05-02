//
//  UdacityClient.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

class UdacityClient {
    
    
    enum Endpoint {
        
        case login
        
        var stringValue : String{
            switch self {
            case .login:
                return "https://onthemap-api.udacity.com/v1/session"
            }
        }
        var url : URL {
            return URL(string: self.stringValue)!
        }
    }
    
    

    
    
    
//class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
//    let body = LoginRequest(username: username, password: password, requestToken: Auth.requestToken)
//    taskForPOSTRequest(url: Endpoints.login.url, responseType: RequestTokenResponse.self, body: body) { response, error in
//        if let response = response {
//            Auth.requestToken = response.requestToken
//            completion(true, nil)
//        } else {
//            completion(false, error)
//        }
//    }
//}
    
}
