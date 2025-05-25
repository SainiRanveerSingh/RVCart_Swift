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
    var callAPIForGettingNextDiscoverSet: ((_ page: Int) -> Void)?
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
}

extension CategoryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryCollectionViewModel?.arrCategories.count ?? 0//arrSmallGrid?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(indexPath: indexPath)
    }
    
    
    func cell (indexPath:IndexPath) ->  CategoryCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configureCell(items: categoryCollectionViewModel?.arrCategories, index: indexPath.row)
        if selectedIndexPath == indexPath {
            cell.makeItSelectedCell()
        } else {
            cell.makeItNormalCell()
        }
        //cell.lblCategory.text = "Cell Item: \(indexPath.item + 1)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath != indexPath {
            didSelect?(indexPath.item)
        }
        if let cell = getCellFor(indexPath: indexPath) {
            cell.makeItSelectedCell()
            selectedIndexPath = indexPath
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


