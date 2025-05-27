//
//  CategoryTableCell.swift
//  RVCart
//
//  Created by RV on 27/05/25.
//

import UIKit

class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var imgCategory: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func configureCell(items:  CategoryData?, index : Int) {
        let category = items?[index]
        lblCategoryName.text = category?.name ?? ""
        if let imageUrl = category?.image {
            imgCategory.downloadImageFrom(urlString: imageUrl, imageMode: .scaleAspectFill)
        }
    }
    
}
