//
//  ViewController.swift
//  RVCart
//
//  Created by RV on 22/05/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if KeychainSecure.instance.getToken(forKey: "RVCartAccessToken") != nil {
            let token = KeychainSecure.instance.getToken(forKey: "RVCartAccessToken")
            if token != "0" {
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                self.navigationController?.pushViewController(homeVC, animated: true)
            } else {
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        } else {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }


}

