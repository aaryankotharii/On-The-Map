//
//  UdacityClient.swift
//  On The Map
//
//  Created by Aaryan Kothari on 02/05/20.
//  Copyright © 2020 Aaryan Kothari. All rights reserved.
//

import Foundation

class UdacityClient {
    
    //MARK:- ENDPOINT URLS
    enum Endpoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case StudentInformation(limit: Int?, order: String?)
        case signup
        case newStudent
        case updateStudent(objectID : String)
        case logout
        
        var stringValue : String{
            switch self {
            case .login:
                return "https://onthemap-api.udacity.com/v1/session"
            case .StudentInformation(limit: let limit, order: let order):
                if let order = order, let limit = limit, !order.isEmpty {
                    return Endpoints.base + "/StudentLocation?order=\(order)&limit=\(limit)"
                }
                return Endpoints.base + "/StudentLocation"
                return "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100"
            case .signup:
                return "https://auth.udacity.com/sign-up"
            case .newStudent:
                return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .updateStudent(let objectId):
                return "https://onthemap-api.udacity.com/v1/StudentLocation/" + objectId
            case .logout:
                return "https://onthemap-api.udacity.com/v1/session"
            }
        }
        
        var url : URL {
            return URL(string: self.stringValue)!
        }
    }
    
    
    //Enum to decide request type
    enum httpMethod: String {
        case PUT
        case POST
    }
    
    //MARK:- GET REQUEST
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
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
        
        return task
    }
    
    //MARK:- POST || PUT REQUEST
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType,isLogin : Bool = false, httpMethod : httpMethod = .POST,completion: @escaping (ResponseType?, Error?) -> Void) {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        let postData = try! JSONEncoder().encode(body)
        
        request.httpBody = postData
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
            let newData = isLogin ? data.subdata(in: Range(uncheckedBounds: (5, data.count))) : data
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
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
    
    
    //MARK:- Login Method
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginUser = User(username: username, password: password)
        let body = Udacity.init(udacity: loginUser)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: Auth.self, body: body, isLogin: true) { response, error in
            if response != nil {
                completion(true,nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //MARK:- GET STudent Locations function
    class func getStudentInformation(limit: Int? = nil , order: String? = "",completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.StudentInformation(limit: limit,order: order).url, responseType: StudentData.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    //MARK:- POST Student Location function
    class func createNewStudentLocation(data: NewStudentRequest,completion: @escaping (Bool,NewStudentResponse?, Error?) -> Void){
        let body =  data
        taskForPOSTRequest(url: Endpoints.newStudent.url, responseType: NewStudentResponse.self, body: body) { response, error in
            if let response = response {
                debugLog(message: "STUDENT LOCATION CREATED")
                completion(true,response ,nil)
            } else {
                completion(false,nil,error)
            }
        }
    }
    
    //MARK:- PUT Student Location function
    /// Function name has post but its httpbody parameter decides request type
    class func updateStudentLocation(data:NewStudentRequest,completion: @escaping (Bool,Error?) -> Void){
        let body = data
        let objectId = UserDefaults.standard.value(forKey: "objectId") as! String
        taskForPOSTRequest(url: Endpoints.updateStudent(objectID: objectId).url,responseType: updtatedStudentResponse.self, body: body,httpMethod: .PUT) { response, error in
            if let _ = response {
                debugLog(message: "STUDENT LOCATION UPDATED")
                completion(true, nil)
            } else {
                completion(false,error)
            }
        }
    }
    
    //MARK:- Logout function
    class func logout(completion: @escaping (Bool, Error?) -> Void){
        
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false,error)
                return
            }
            debugLog(message: "LOGOUT SUCCESSFUL")
            completion(true,nil)
        }
        task.resume()
    }
}
