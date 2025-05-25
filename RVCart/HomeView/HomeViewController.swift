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
    var selectedCategoryID = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        loadCategories()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNagigationBar()
    }
    
    func initialSetup() {
        setupNagigationBar()
        collectionViewCategory.configure(homeViewModel)
        collectionViewCategory.didSelect = { [weak self] (index) in
            guard let self = self else { return }
            self.selectedCategoryID = self.homeViewModel.getCategoryIdAt(index: index)
            print("Selected Category ID: \(self.selectedCategoryID)")
        }
    }
    
    func setupNagigationBar() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Products"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarBorderColor(themeColor)
    }
    
    func loadCategories() {
        LoadingView.sharedInstance.showLoader(msg: "")
        homeViewModel.loadProductCategories { status, message in
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
                    let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
                        // ...
                    }
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    

}
