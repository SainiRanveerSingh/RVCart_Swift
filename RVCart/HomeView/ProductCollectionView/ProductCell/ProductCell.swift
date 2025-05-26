//
//  ProductCell.swift
//  RVCart
//
//  Created by RV on 26/05/25.
//

import UIKit

class ProductCell: UICollectionViewCell {

    //title, price, description, and image (GIF placeholder)
    @IBOutlet weak var viewProduct: UIView!
    @IBOutlet weak var imgProduct: CustomImageView!
    @IBOutlet weak var lblProductTitle: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var lblProductDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }

    func initialSetup() {
        /*
        viewProduct.clipsToBounds = true
        viewProduct.layer.cornerRadius = 25
        viewProduct.backgroundColor = themeColor.withAlphaComponent(0.2)
        viewProduct.layer.borderColor = themeColor.cgColor
        viewProduct.layer.borderWidth = 1.0
        */
        /*
        imgProduct.layer.borderColor = themeColor.cgColor
        imgProduct.layer.borderWidth = 1.0
        imgProduct.layer.cornerRadius = 5
        */
        lblProductTitle.textColor = themeColor
        //lblProductDescription.textColor = themeColor.withAlphaComponent(0.6)
    }
    
    func configureCell(items:  Products?, index : Int) {
        if items?.count ?? 0 > index {
        let product = items?[index]
        lblProductTitle.text = product?.title
        lblProductPrice.text = "\(product?.price ?? 0)"
        lblProductDescription.text = product?.description
        
        if let imageUrls = product?.images {
            if imageUrls.count > 0 {
                if imageUrls[0] != "" {
                    //imgProduct.downloadImageFrom(urlString: imageUrls[0], imageMode: .center)
                    
                    guard let url = URL(string: imageUrls[0]) else { return }
                    imgProduct.sd_setImage(with: url, placeholderImage: UIImage(named: "shopping"))
                }
            }
        }
    }
    }
}
