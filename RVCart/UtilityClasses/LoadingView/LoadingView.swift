//
//  LoadingView.swift
//  RVCart
//
//  Created by RV on 24/05/25.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblmsg: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
    static let sharedInstance = LoadingView.initLoader()
    
    class func initLoader() -> LoadingView {
        return UINib(nibName: "LoadingView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LoadingView
    }
    
    override func awakeFromNib() {
        //self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewBackground.clipsToBounds = true
        viewBackground.layer.cornerRadius = 15
    }
    
    func showLoader(msg : String) {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.view.addSubview(self)
        
        self.frame = UIScreen.main.bounds
        
        lblmsg.text = msg
       
        startAnimation()
    }
    

    func startAnimation(){
        
        DispatchQueue.main.async(execute: {
            self.activityIndicator.startAnimating()
        })
    }
    
    //MARK: Stop loader
    func stopLoader() {
        
        DispatchQueue.main.async(execute: {
            self.activityIndicator.stopAnimating()
               UIView.animate(withDuration: 0.1, animations: {
                   
               }) { (_) in
                      self.removeFromSuperview()
               }
        })
}
}

/*
 calling like :
 LoadingView.sharedInstance.showLoader(msg: "loading main view ")    //-->> Start Loader
 
 LoadingView.sharedInstance.stopLoader()          //-->> Stop loader
 
 */
