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
        
#if DEBUG
        txtEmailAddress.text = "john@mail.com"
        txtPassword.text = "changeme"
#endif
        
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
        LoadingView.sharedInstance.showLoader(msg: "")
        loginViewModel.login(email: txtEmailAddress.text ?? "", password: txtPassword.text ?? "") { status, message in
            LoadingView.sharedInstance.stopLoader()
            if status {
                
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                        // ...
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
