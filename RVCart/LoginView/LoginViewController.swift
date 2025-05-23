//
//  LoginViewController.swift
//  RVCart
//
//  Created by RV on 22/05/25.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    //Variables
    var loginViewModel = LoginViewModel()
    
    //IBOutlets
    @IBOutlet weak var viewLogin: UIView!
    @IBOutlet weak var viewEmailAddress: UIView!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        // Do any additional setup after loading the view.
    }
    
    func initialSetup() {
        viewLogin.clipsToBounds = true
        viewLogin.layer.cornerRadius = 20
        viewLogin.layer.borderWidth = 1.0
        viewLogin.layer.borderColor = UIColor(_colorLiteralRed: 0/255, green: 113/255, blue: 201/255, alpha: 1.0).cgColor
        
        viewEmailAddress.clipsToBounds = true
        viewEmailAddress.layer.cornerRadius = 10
        
        viewPassword.clipsToBounds = true
        viewPassword.layer.cornerRadius = 10
        
        btnLogin.clipsToBounds = true
        btnLogin.layer.cornerRadius = 10
    }
    
    @IBAction func btnLogin(_ button: UIButton) {
        loginViewModel.login(email: txtEmailAddress.text ?? "", password: txtPassword.text ?? "") { status, message in
            if status {
                
            }
        }
    }
}
