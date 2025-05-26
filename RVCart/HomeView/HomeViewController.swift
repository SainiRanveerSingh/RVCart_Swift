//
//  HomeViewController.swift
//  RVCart
//
//  Created by RV on 24/05/25.
//

import UIKit

class HomeViewController: UIViewController {

    let homeViewModel = HomeViewModel()
    @IBOutlet weak var collectionViewCategory: CategoryCollectionView!
    @IBOutlet weak var collectionViewProducts: ProductCollectionView!
    var selectedCategoryID = -1
    var selectedProduct = -1
    var refresher:UIRefreshControl!
    var isScrolledToLoadMoreData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        loadCategories()
        loadProducts() 
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNagigationBar()
    }
    
    func initialSetup() {
        setupNagigationBar()
        hideKeyboardWhenTappedAround()
        
        //Category Collection View
        collectionViewCategory.configure(homeViewModel)
        collectionViewCategory.didSelect = { [weak self] (index) in
            guard let self = self else { return }
            if index != -1 {
                self.selectedCategoryID = self.homeViewModel.getCategoryIdAt(index: index)
                self.homeViewModel.selectedCategoryId = self.selectedCategoryID
                print("Selected Category ID: \(self.selectedCategoryID)")
            } else {
                self.selectedCategoryID = index
                self.homeViewModel.selectedCategoryId = index
            }
            self.homeViewModel.isMoreDataAvailable = true
            self.homeViewModel.offsetValue = 0
            self.loadProducts()
        }
        
        //Product Collection View
        collectionViewProducts.configure(homeViewModel)
        collectionViewProducts?.didSelect = { [weak self] (index) in
            guard let self = self else { return }
            self.selectedProduct = index
        }
        
        collectionViewProducts.callAPIForGettingNextSet = { [weak self] (currentOffset) in
            guard let self = self else { return }
            self.homeViewModel.offsetValue += 1
            self.isScrolledToLoadMoreData = true
            self.loadProducts()
        }
        
        self.refresher = UIRefreshControl()
        self.collectionViewProducts.alwaysBounceVertical = true
        self.refresher.tintColor = themeColor
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        //self.collectionViewProducts.addSubview(refresher)
        self.collectionViewProducts.refreshControl = refresher
    }
    
    func setupNagigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Products"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarBorderColor(themeColor)
    }
    
    func loadCategories() {
        LoadingView.sharedInstance.showLoader(msg: "")
        homeViewModel.loadProductCategories { [weak self] status, message in
            guard let self = self else { return }
            LoadingView.sharedInstance.stopLoader()
            if status {
                DispatchQueue.main.async {
                    //Reload Collection View
                    self.collectionViewCategory.displayData()
                }
                if self.homeViewModel.arrCategories.count > 1 {
                    //Image on first Index was getting updated so reloaded the cell with delay of 0.5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        DispatchQueue.main.async {
                            let indexPath = IndexPath(item: 0, section: 0)
                            self.collectionViewCategory.reloadItems(at: [indexPath])
                        }
                    }
                }
            } else {
                //Error
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", and: message)
                }
            }
        }
    }
    
    //Pull To Referesh Metthod Called
    @objc func loadData() {
        self.collectionViewProducts!.refreshControl?.beginRefreshing()
        self.homeViewModel.offsetValue = 0
        self.homeViewModel.isMoreDataAvailable = true
        self.loadProducts()
    }
    
    func stopRefresher() {
        self.collectionViewProducts!.refreshControl?.endRefreshing()
        self.isScrolledToLoadMoreData = false
        //refresher.endRefreshing()
     }
    
    func loadProducts() {
        if !self.isScrolledToLoadMoreData {
            LoadingView.sharedInstance.showLoader(msg: "")
        }
        homeViewModel.loadProductData { [weak self] status, message in
            guard let self = self else { return }
            
            LoadingView.sharedInstance.stopLoader()
            DispatchQueue.main.async {
                //Stop refresher
                self.stopRefresher()
            }
            if status {
                DispatchQueue.main.async {
                    //Reload Collection View
                    self.collectionViewProducts.displayData()
                    if message == "There are no products available in the category you have selected." {
                        self.showAlertWith(title: "RVCart", and: message)
                    } else if message == "No more products available to show." {
                        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        let when = DispatchTime.now() + 2
                        DispatchQueue.main.asyncAfter(deadline: when){
                          // your code with delay
                          alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else {
                //Error
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", and: message)
                }
            }
        }
    }
    
    func showAlertWith(title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            // ...
        }
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }

}
