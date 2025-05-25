//
//  AppUrl.swift
//  RVCart
//
//  Created by RV on 22/05/25.
//

import Foundation

//POST https://api.escuelajs.co/api/v1/auth/login
struct APPURL {
    private struct Domains {
        static let Live = "https://api.escuelajs.co/"
        static let TestQA = ""
    }
    
    private  struct Routes {
        static let Api = "api/"
    }
    
    private  struct Versions {
        static let V1 = "v1/"
    }
    
    private  struct Authentication {
        static let Auth = "auth/"
    }
    
    private  static let Domain = Domains.Live
    private  static let Route = Routes.Api
    private  static let Version = Versions.V1
    private  static let Auth = Authentication.Auth
    private  static let BaseURL = Domain + Route + Version
    
    struct Urls {
        
        static var Login : String {
            return BaseURL  + Auth + "login"
        }
        
        static var Profile : String {
            return BaseURL  + Auth + "profile"
        }
        
        static var Categories : String {
            return BaseURL + "categories"
        }
        
        static var Products : String {
            return BaseURL + "products"
        }
        
    }
}
