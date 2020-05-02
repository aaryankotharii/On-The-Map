//
//  UdacityClient.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

class UdacityClient {
    
    
    enum Endpoints {
        
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
    
    enum httpBody {
        case login(String,String)
        
        var stringValue : String{
            switch self {
            case .login(let username, let password):
                return "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
            }
        }
        var data : Data {
            return self.stringValue.data(using: .utf8) ?? Data()
        }
    }
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
       // request.httpBody = try! JSONEncoder().encode(body)
        request.httpBody = "{\"udacity\": {\"username\": \"z@k.com\", \"password\": \"xoqrod-poxni8-xoQpug\"}}".data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }

    
    

    
    
    
class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
    let body = "{\"udacity\": {\"username\": \"z@k.com\", \"password\": \"xoqrod-poxni8-xoQpug\"}}".data(using: .utf8)
    taskForPOSTRequest(url: Endpoints.login.url, responseType: ErrorResponse.self, body: body) { response, error in
        if let response = response {
            print(response,"Response")
            completion(true, nil)
        } else {
            completion(false, error)
        }
    }
}
    
    
    
}
