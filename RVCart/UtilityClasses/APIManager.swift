//
//  APIManager.swift
//  RVCart
//
//  Created by RV on 23/05/25.
//

import Foundation
import Combine
final class APIManager {
    
    
    class func post(params : Dictionary<String, String>, url : String, completionHandler:@escaping ([String: Any]?, Error?) -> Void) { //[String: Any]?, Error?
        var cancellable = Set<AnyCancellable>()
        
        //let parameters = ["email": "john@mail.com", "password": "changeme"]
        
        let requestBody = try? JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
        /*
        var urlComponents = URLComponents(string: url)!
        urlComponents.scheme = "https"
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: "john@mail.com"),
            URLQueryItem(name: "password", value: "changeme")
        ]
        let newURL = urlComponents.url!
        //urlComponents.host = url
        */
        guard let requestUrl = URL(string: url) else
        {
            completionHandler(nil, NSError(domain: "invalidURLTypeError", code: URLError.badURL.rawValue) )
            return
        }
        //let requestUrl = urlComponents.url!
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = "POST"
        request.httpBody = requestBody
        
        //request.addValue(authorizationToken, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //--
        let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                  if (error != nil) {
                      print(error ?? "Something went wrong")
                  } else {
                    let httpResponse = response as? HTTPURLResponse
                      print(data ?? "No Data")
                      print(response ?? "No Response")
                      print(httpResponse?.statusCode ?? "404 Not Found")
                      
                      guard let data = data else {
                          completionHandler(nil,NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                          return
                      }
                      
                      do {
                          //create json object from data
                          guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                              completionHandler(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                              return
                          }
                          print(json)
                          completionHandler(json, nil)
                      } catch let error {
                          print(error.localizedDescription)
                          completionHandler(nil, error)
                      }
                      
                  }
                    
                    // parse the result as JSON, since that's what the API provides
                    /*
                    var result: Signup1ResponseModel?
                    do{
                        result = try JSONDecoder().decode(Signup1ResponseModel.self, from: data!)
                    }
                    catch {
                        print("Failed to convert JSON \(error)")
                    }
                    */
                    //print(result)
                    //completionHandler(Data())
                    
                })

                dataTask.resume()
                
        //--
        /*
        URLSession.shared
            .dataTaskPublisher(for: request)
            .print()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }, receiveValue: { responseData in
                print("Data: \(responseData.data)")
                completionHandler(responseData.data)
            })
            .store(in: &cancellable)
        */
    }
}
