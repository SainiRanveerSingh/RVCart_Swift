//
//  HomeViewModel.swift
//  RVCart
//
//  Created by RV on 24/05/25.
//

import Foundation
final class HomeViewModel {
    func loadData() {
        
    }
    
    func loadProductCategories() {
        APIManager.get(params: ["":""], url: APPURL.Urls.Categories, addAccessToken: true) { dataValue, error in
            if error == nil {
                print(dataValue?.count ?? "No Data Found")
            } else {
                print(error ?? "Something went wrong")
            }
        }
    }
}
