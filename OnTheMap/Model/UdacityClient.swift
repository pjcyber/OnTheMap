//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Pjcyber on 4/8/20.
//  Copyright © 2020 Pjcyber. All rights reserved.
//

import Foundation
import FacebookLogin

// this class is to do all the Rest calls
class UdacityClient {
    
    // Authorization model
    struct Auth {
        static var sessionId = ""
        static var accountKey = ""
        static var expiration = ""
    }
    
    // Endpoints model
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case addLocation
        case locations
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .addLocation:
                return Endpoints.base + "/StudentLocation"
            case .locations:
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    // GETRequest funtion
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
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
    
    // POSTRequest funtion
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            let range: CountableRange = 5..<data!.count
            let newData = data?.subdata(in: range) /* subset response data! */
            guard let data = newData else {
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
    
    // Login request
    class func login(udacity: Udacity, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: udacity)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: RequestSessionResponse.self, body: body) { response, error in
            if let response = response {
                let dateString = response.session.expiration.replacingOccurrences(of: "T", with: " ")
                let substring = dateString.split(separator: ".")
                let expiration = String(substring[0])
                
                storeAutoriation(accountKey: response.account.key, sessionId: response.session.id, expiration: expiration)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // Login request with facebook
    class func loginWithFacebook(completion: @escaping (Bool, Error?) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil, handler: { result, error -> Void in
            if error != nil {
                completion(false, error)
            } else if (result?.isCancelled)! {
                completion(false, nil)
            } else {
                guard let token = result?.token else {
                    return
                }
                
                storeAutoriation(accountKey: token.appID, sessionId: token.tokenString, expiration: token.expirationDate.description)
                
                completion(true, nil)
            }
        })
    }
    
    // Logout
    class func logout() {
        Auth.accountKey = ""
        Auth.sessionId =  ""
        Auth.expiration = ""
    }
    
    // verify if the token is expired
    class func isTokenExpired() -> Bool {
        let isTokenExpired = Auth.expiration == getCurrentTime()
        if isTokenExpired {
           logout()
        }
        return isTokenExpired
    }
    
    // get students location
    class func getLocations(completion: @escaping ([StudentInformation], Error?) -> Void) {
        _ = taskForGETRequest(url: Endpoints.locations.url, responseType: LocationResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    // Post student location
    class func addStudentLocation(locationRequest: LocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        taskForPOSTRequest(url: Endpoints.addLocation.url, responseType: RequestSessionResponse.self, body:
        locationRequest) { _, error in
            if error == nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // Store Authorization data
    class func storeAutoriation(accountKey: String, sessionId: String, expiration: String) {
        Auth.accountKey = accountKey
        Auth.sessionId =  sessionId
        Auth.expiration = expiration
    }
    
    class func getCurrentTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let creationDate = formatter.string(from: date)
        
        return creationDate
    }
}
