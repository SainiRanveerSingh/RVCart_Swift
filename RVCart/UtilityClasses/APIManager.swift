//
//  APIManager.swift
//  RVCart
//
//  Created by RV on 23/05/25.
//

import Foundation
import Combine
final class APIManager {
    
    /*
     401 Unauthorized: Invalid credentials or expired tokens
     403 Forbidden: Valid authentication but insufficient permissions
     400 Bad Request: Malformed request body or headers
    */
    class func post(params : Dictionary<String, String>, url : String, addAccessToken: Bool, completionHandler:@escaping (_ dataValue: Data?, String?) -> Void) { //[String: Any]?, Error?
        
        //TODO: Testing
        //let parameters = ["email": "john@mail.com", "password": "changeme"]
        
        let requestBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        guard let requestUrl = URL(string: url) else
        {
            completionHandler(nil, "Please try again.")
            return
        }
        //let requestUrl = urlComponents.url!
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = "POST"
        request.httpBody = requestBody
        //Authorization: Bearer {your_access_token}
        if addAccessToken {
            var token = KeychainSecure.instance.getToken(forKey: "accessToken") ?? ""
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //--
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Something went wrong")
                completionHandler(nil, error?.localizedDescription)
            } else {
                guard let data = data else {
                    completionHandler(nil,"Data not found. Please try again.")
                    return
                }
                if let dataValue = try? JSONDecoder().decode(FailureResponse.self, from: data) {
                    print(dataValue.message)
                    completionHandler(nil, dataValue.message)
                }
                
                completionHandler(data, nil)
            }
        })
        
        dataTask.resume()
    }
    
    /*
     GET https://api.escuelajs.co/api/v1/auth/profile
     Authorization: Bearer {your_access_token}
    */
    class func get(params : Dictionary<String, String>, url : String, addAccessToken: Bool, completionHandler:@escaping (_ dataValue: Data?, String?) -> Void) {
        let requestBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        guard let requestUrl = URL(string: url) else
        {
            completionHandler(nil, "Please try again.")
            return
        }
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = "GET"
        //request.httpBody = requestBody
        
        //request.addValue("Bearer \()", forHTTPHeaderField: "Authorization")
        if addAccessToken {
            let token = KeychainSecure.instance.getToken(forKey: "accessToken") ?? ""
            let authorizationToken = "Bearer " + token
            request.addValue(authorizationToken, forHTTPHeaderField: "Authorization")
            //request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error ?? "Something went wrong")
                completionHandler(nil, error?.localizedDescription)
            } else {
                let httpResponse = response as? HTTPURLResponse
                
                if let errorCode = httpResponse?.statusCode as? Int {
                    if errorCode == 401 {
                        completionHandler(nil, "Invalid User. Please use correct Email or Password") //Unauthorized User
                    }
                }
                
                guard let data = data else {
                    completionHandler(nil,"User not found. Please try again.")
                    return
                }
                do {
                    //create json object from data
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        completionHandler(nil,"User not found. Please try again.")
                        return
                    }
                    print(json)
                    if let statusCode = json["statusCode"] as? Int {
                        let message = json["message"] as? String
                        if statusCode == 401 {
                            completionHandler(nil, message ?? "Unauthorized User. Please check your Login credentials and try again.")
                        }
                    }
                    completionHandler(data, nil)
                } catch let error {
                    print(error.localizedDescription)
                    completionHandler(nil, error.localizedDescription)
                }
            }
        })
        
        dataTask.resume()
    }
    
}
