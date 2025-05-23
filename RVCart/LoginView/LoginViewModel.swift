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
        
        
        
    }
    
}
