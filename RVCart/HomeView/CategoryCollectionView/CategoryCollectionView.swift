//
//  CategoryCollectionView.swift
//  RVCart
//
//  Created by RV on 25/05/25.
//

import Foundation
import UIKit

class CategoryCollectionView: UICollectionView {
    var indexOfPageRequest = (value : 0,isLoadingStatus: false) // for paggination
    var didSelect: ((_ index: Int) -> Void)?
    var callAPIForGettingNextSet: ((_ page: Int) -> Void)?
    var categoryCollectionViewModel : HomeViewModel!
    var selectedIndexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ viewModel: HomeViewModel) {
        self.categoryCollectionViewModel = viewModel
        dataSource = self
        delegate = self
        //Cell registration
        let nib = UINib.init(nibName: "CategoryCell", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    func displayData() {
        reloadData()
    }
    
    
    func clearCategorySelection() {
        if let selectedIndex = selectedIndexPath {
            if let cell = getCellFor(indexPath: selectedIndex) {
                cell.makeItNormalCell()
            }
            selectedIndexPath = nil
            didSelect?(-1)
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
}

extension CategoryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryCollectionViewModel?.arrCategories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(indexPath: indexPath)
    }
    
    
    func cell (indexPath:IndexPath) ->  CategoryCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configureCell(items: categoryCollectionViewModel?.arrCategories, index: indexPath.row)
        if let selectedIndex = selectedIndexPath {
            cell.makeItNormalCell()
            if selectedIndex == indexPath {
                cell.makeItSelectedCell()
            }
        }
        //cell.lblCategory.text = "Cell Item: \(indexPath.item + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath != indexPath {
            didSelect?(indexPath.item)
            if let cell = getCellFor(indexPath: indexPath) {
                cell.makeItSelectedCell()
                selectedIndexPath = indexPath
            }
        } else {
            if let cell = getCellFor(indexPath: indexPath) {
                cell.makeItNormalCell()
                selectedIndexPath = nil
                didSelect?(-1)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = getCellFor(indexPath: indexPath) {
            cell.makeItNormalCell()
        }
    }
    
    
    func getCellFor(indexPath: IndexPath) -> CategoryCell? {
        return self.cellForItem(at: indexPath) as? CategoryCell
    }
    
}


