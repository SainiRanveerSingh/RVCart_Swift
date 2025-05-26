//
//  ProductCollectionView.swift
//  RVCart
//
//  Created by RV on 26/05/25.
//

import UIKit

class ProductCollectionView: UICollectionView {
    var indexOfPageRequest = (value : 0,isLoadingStatus: false) // for paggination
    var didSelect: ((_ index: Int) -> Void)?
    var callAPIForGettingNextSet: ((_ page: Int) -> Void)?
    var productCollectionViewModel : HomeViewModel!
    var selectedIndexPath : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(_ viewModel: HomeViewModel) {
        self.productCollectionViewModel = viewModel
        dataSource = self
        delegate = self
        //Cell registration
        let nib = UINib.init(nibName: "ProductCell", bundle: nil)
        self.register(nib, forCellWithReuseIdentifier: "ProductCell")
        setUpCollectionView()
    }
    
    func displayData() {
        reloadData()
    }
    
    func setUpCollectionView() {
        
        let collectionFlowLayout = UICollectionViewFlowLayout()
        
        collectionFlowLayout.scrollDirection = .vertical
        let widthHeight = (self.frame.size.width - 4)/2
        collectionFlowLayout.itemSize = CGSize(width: widthHeight, height: widthHeight + 100)
        self.setCollectionViewLayout(collectionFlowLayout, animated: true)
    }
    
}

extension ProductCollectionView: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productCollectionViewModel?.arrProducts.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(indexPath: indexPath)
    }
    
    func cell (indexPath:IndexPath) ->  ProductCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCell
        cell.configureCell(items: productCollectionViewModel?.arrProducts, index: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndexPath != indexPath {
            didSelect?(indexPath.item)
            selectedIndexPath = indexPath
        }
    }
}


extension ProductCollectionView {
    
 func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     if productCollectionViewModel.arrProducts.count - 2 == indexPath.item {
         //Load more data and append it
         if self.productCollectionViewModel.isMoreDataAvailable {
             callAPIForGettingNextSet?(self.productCollectionViewModel.offsetValue)
         }
     }
 
 }
}

