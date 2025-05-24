//
//  LoginViewModel.swift
//  RVCart
//
//  Created by RV on 22/05/25.
//

import Foundation
final class LoginViewModel {
    
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    func login(email: String, password: String, completion: @escaping (_ status: Bool, _ message: String) -> Void) {
        //--Checking Email and Password--
        if email.isEmpty {
            completion (false, ErrorMessages.emailRequired)
        }
        
        let isValidEmail = NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
        
        if !isValidEmail {
            completion (false, ErrorMessages.validMail)
        }
        if password.isEmpty {
            completion (false, ErrorMessages.passwordRequired)
        }
        
        let param = ["email": email, "password": password]
        
        APIManager.post(params: param, url: APPURL.Urls.Login, addAccessToken: false) { responseData, error in
            if error == nil {
                print(responseData?.count ?? "No Data Found")
                guard let data = responseData else {
                    completion(false, error ?? "Something went wrong. Please try again.")
                    return
                }
                do {
                    if let dataValue = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                        print(dataValue.accessToken)
                        try? KeychainSecure.instance.saveToken(dataValue.accessToken, forKey: "accessToken")
                        self.getUserProfileData()
                        completion(true, "Got the Data")
                    } else {
                        print("Change in Response Data Structure")
                        completion(false, "Something went wrong. Please try again.")
                    }
                }
            } else {
                print(error ?? "Error!!!")
                if error == "Unauthorized" {
                    completion(false, "Unauthorized or Invalid User Credentials. Please use correct Email or Password")
                }
                completion(false, error ?? "Something went wrong. Please try again.")
            }
        }
    }
    
    func getUserProfileData() {
        let param = ["":""]
        APIManager.get(params: param, url: APPURL.Urls.Profile, addAccessToken: true) { dataValue, error in
            if error == nil {
                guard let data = dataValue else {
                    //completion(false, error ?? "Something went wrong. Please try again.")
                    return
                }
                print(dataValue?.count ?? "Empty Data")
                do {
                    if let userData = try? JSONDecoder().decode(UserProfileModel.self, from: data) {
                        print(userData.name)
                    } else {
                        print("Got error: \(error ?? "")")
                    }
                }
            } else {
                print(error ?? "Error!!!")
            }
        }
    }
}
