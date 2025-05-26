//
//  FilterView.swift
//  RVCart
//
//  Created by RV on 26/05/25.
//

import UIKit
import Foundation

class FilterView: UIView {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var centerSpace: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblSelectedCategory: UILabel!
    @IBOutlet weak var lblMinPrice: UILabel!
    @IBOutlet weak var lblMaxPrice: UILabel!
    
    @IBOutlet weak var btnApplyFilter: UIButton!
    @IBOutlet weak var btnClearFilter: UIButton!
    
    class func initLoader() -> FilterView {
        return UINib(nibName: "FilterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterView
    }
    
    static let sharedInstance = FilterView.initLoader()
    var onCloser : ((_ categoryID: Int, _ minPrice: Int, _ maxPrice: Int)-> Void)!
    
    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.viewBackground.isHidden = true
        initialSetup()
    }
    
    //MARK:- Main Method -
    func ShowPopup(categoryID: Int, onCompletion: @escaping (_ categoryID: Int, _ minPrice: Int, _ maxPrice: Int)-> Void) {
        self.frame = UIScreen.main.bounds
        self.onCloser = onCompletion
        print("selectedCategoryID in Filter Pop up: \(categoryID)")
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController?.view.addSubview(self)//-->> add to subview
        self.showWithAnimation()
        self.layoutIfNeeded()
    }
    
    //MARK:- Methods -
    func showWithAnimation() {
        //============== Show with animation
        
        self.centerSpace.constant = -UIScreen.main.bounds.height
        self.viewBackground.isHidden = true
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.centerSpace.constant = 0
        }) { _ in
            //self.viewInnerContainer.removeFromSuperview()
            self.viewBackground.isHidden = false
        }
    }
    
    func removeWithAnimation(){
        //============== remove with animation
        self.viewBackground.isHidden = true
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.centerSpace.constant = -UIScreen.main.bounds.height
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    func initialSetup() {
        viewBackground.clipsToBounds = true
        viewBackground.layer.cornerRadius = 25
        viewBackground.layer.borderColor = themeColor.cgColor
        viewBackground.layer.borderWidth = 1.0
        
        btnClose.clipsToBounds = true
        btnClose.layer.cornerRadius = 20
        btnClose.layer.borderColor = themeColor.cgColor
        btnClose.layer.borderWidth = 2.0
        
        viewCategory.clipsToBounds = true
        viewCategory.layer.cornerRadius = 15
        viewCategory.layer.borderColor = themeColor.cgColor
        viewCategory.layer.borderWidth = 1.0
        
        btnApplyFilter.clipsToBounds = true
        btnApplyFilter.layer.cornerRadius = 10
        
        btnClearFilter.clipsToBounds = true
        btnClearFilter.layer.cornerRadius = 10
    }
    
    @IBAction func btnSelectCategory(_ sender: UIButton) {
        print("Select Category Button Clicked")
    }
    
    @IBAction func btnApplyFilter(_ sender: UIButton) {
        print("Select Apply Filter Button Clicked")
        onCloser(1, 0, 0)
        removeWithAnimation()
    }
    
    @IBAction func btnClearFilter(_ sender: UIButton) {
        print("Select Cancel Filter Button Clicked")
        onCloser(-1, -1, -1)
        removeWithAnimation()
    }
    
    @IBAction func btnCloseFilter(_ sender: UIButton) {
        print("Select Cancel Filter Button Clicked")
        removeWithAnimation()
    }

}
