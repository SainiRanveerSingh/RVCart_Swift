//
//  FilterCategoryTableView.swift
//  RVCart
//
//  Created by RV on 27/05/25.
//

import UIKit

class FilterCategoryTableView: UITableView {

    var arrCategories : CategoryData = CategoryData()
    var didSelect: ((_ index: Int) -> Void)?
    
    func configure(_ arrayCategory: CategoryData) {
        self.arrCategories = arrayCategory
        dataSource = self
        delegate = self
        //Cell registration
        let nib = UINib.init(nibName: "CategoryTableCell", bundle: nil)
        self.register(nib, forCellReuseIdentifier: "CategoryTableCell")
    }
    
    func displayData() {
        reloadData()
    }
    

}

extension FilterCategoryTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(indexPath: indexPath)
    }
    
    func cell (indexPath:IndexPath) ->  CategoryTableCell {
        let cell = dequeueReusableCell(withIdentifier: "CategoryTableCell", for: indexPath) as! CategoryTableCell
        cell.configureCell(items: arrCategories, index: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(indexPath.row)
    }
    
}
