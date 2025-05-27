//
//  FilterView.swift
//  RVCart
//
//  Created by RV on 26/05/25.
//

import UIKit
import Foundation
import MultiSlider

class FilterView: UIView {
    
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var centerSpace: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var lblSelectedCategory: UILabel!
    
    //Category Table View as Drop down
    @IBOutlet weak var viewCategoryDropdown: UIView!
    @IBOutlet weak var dropDownHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblCategoryDropDown: FilterCategoryTableView!
    
    @IBOutlet weak var lblMinPrice: UILabel!
    @IBOutlet weak var lblMaxPrice: UILabel!
    
    @IBOutlet weak var btnApplyFilter: UIButton!
    @IBOutlet weak var btnClearFilter: UIButton!
    
    @IBOutlet weak var viewPriceSlider: UIView!
    var sliderPriceRange = MultiSlider()
    
    var arrCategories : CategoryData = CategoryData()
    var selectedCategoryIndex = -1
    var minimumPrice = 1
    var maximumPrice = 1000
    
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
        
        tblCategoryDropDown.didSelect = { [weak self] (index) in
            guard let self = self else { return }
            
            
        }
        
    }
    
    func setupPriceSlider() {
        
        //--
        //let horizontalMultiSlider = MultiSlider()
        sliderPriceRange.orientation = .horizontal
        sliderPriceRange.minimumValue = 1
        sliderPriceRange.maximumValue = 1000
        sliderPriceRange.outerTrackColor = .gray
        sliderPriceRange.value = [1, 1000]
        sliderPriceRange.valueLabelPosition = .top
        sliderPriceRange.tintColor = themeColor
        sliderPriceRange.trackWidth = 32
        sliderPriceRange.showsThumbImageShadow = false
        sliderPriceRange.valueLabelAlternatePosition = true
        sliderPriceRange.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
        
        sliderPriceRange.frame = CGRect(x: 0, y: 0, width: viewPriceSlider.frame.size.width, height: 30)
        sliderPriceRange.tag = 1023
        if viewPriceSlider.viewWithTag(1023) == nil {
            viewPriceSlider.addSubview(sliderPriceRange)
        }
        
        //--
       
    }
    
    //MARK:- Main Method -
    func ShowPopup(categoryID: Int, categoryArray: CategoryData, minPrice: Int, maxPrice: Int, onCompletion: @escaping (_ categoryID: Int, _ minPrice: Int, _ maxPrice: Int)-> Void) {
        self.frame = UIScreen.main.bounds
        selectedCategoryIndex = categoryID
        arrCategories = categoryArray
        minimumPrice = minPrice
        maximumPrice = maxPrice
        setupPriceSlider()
        sliderPriceRange.value = [CGFloat(minPrice), CGFloat(maxPrice)]
        
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
    
    //Price Slider Methods
    @objc func sliderChanged(_ slider: MultiSlider) {
        print("thumb \(slider.draggedThumbIndex) moved")
        print("now thumbs are at \(slider.value)") // e.g., [1.0, 4.5, 5.0]
        
        if Int(slider.value.first ?? 1) == 0 {
            minimumPrice = 1
        } else {
            minimumPrice = Int(slider.value.first ?? 1)
        }
        
        maximumPrice = Int(slider.value.last ?? 1000)
    }
    
    @objc func sliderDragEnded(_ slider: MultiSlider) {
        print("draging ends")
    }
    
    @IBAction func btnSelectCategory(_ sender: UIButton) {
        print("Select Category Button Clicked")
        viewCategoryDropdown.isHidden = false
        self.layoutIfNeeded()    // Change to view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5) {
            self.dropDownHeightConstraint.constant = 130.0
            self.layoutIfNeeded() // Change to view.layoutIfNeeded()
        }
    }
    
    @IBAction func btnApplyFilter(_ sender: UIButton) {
        print("Select Apply Filter Button Clicked")
        onCloser(selectedCategoryIndex, minimumPrice, maximumPrice) //(categoryIndex, minPrice, maxPrice)
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
