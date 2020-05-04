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
        case StudentInformation
        case signup
        case newStudent
        case updateStudent(objectID : String)
        case logout
        
        var stringValue : String{
            switch self {
            case .login:
                return "https://onthemap-api.udacity.com/v1/session"
            case .StudentInformation:
                return "https://onthemap-api.udacity.com/v1/StudentInformation?order=-updatedAt"
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
    
    
    
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType,isLogin : Bool = false, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // request.httpBody = try! JSONEncoder().encode(body)
        //request.httpBody = (body as! Data)
        let postData = try! JSONEncoder().encode(body)
        print(postData)
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
    
    
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginUser = User(username: username, password: password)
        let body = Udacity.init(udacity: loginUser)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: Auth.self, body: body, isLogin: true) { response, error in
            if let response = response {
                print(response,"Response")
                //Auth.requestToken = response.requestToken
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
   class func getStudentInformation(completion: @escaping ([StudentInformation], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.StudentInformation.url, responseType: StudentData.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func createNewStudentLocation(data: NewStudentRequest,completion: @escaping (Bool, Error?) -> Void){
        let body =  data
        taskForPOSTRequest(url: Endpoints.newStudent.url, responseType: NewStudentResponse.self, body: body) { response, error in
            if let response = response {
                print(response,"Response")
                //NewStudentResponse = response
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    class func logout(completion: @escaping () -> Void) {
        
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
            if error != nil { // Handle error…
                return
            }
            let newData = data!.subdata(in: Range(uncheckedBounds: (5, data!.count)))
            print(String(data: newData, encoding: .utf8)!)
        }
        task.resume()
    }
}
