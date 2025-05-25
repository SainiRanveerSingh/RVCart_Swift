//
//  CategoryCell.swift
//  RVCart
//
//  Created by RV on 25/05/25.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var viewCategory: UIView!
    @IBOutlet weak var imgCategory: CustomImageView!
    @IBOutlet weak var lblCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }
    
    func initialSetup() {
        viewCategory.clipsToBounds = true
        viewCategory.layer.cornerRadius = 25
        viewCategory.backgroundColor = themeColor.withAlphaComponent(0.2)
        
        imgCategory.clipsToBounds = true
        imgCategory.layer.cornerRadius = 20
        
        lblCategory.textColor = themeColor
    }
    
    func configureCell(items:  CategoryData?, index : Int) {
        let category = items?[index]
        lblCategory.text = category?.name ?? ""
        if let imageUrl = category?.image {
            imgCategory.downloadImageFrom(urlString: imageUrl, imageMode: .scaleAspectFill)
        }
        
     
    }

}
