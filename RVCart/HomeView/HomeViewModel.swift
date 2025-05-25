//
//  HomeViewModel.swift
//  RVCart
//
//  Created by RV on 24/05/25.
//

import Foundation
final class HomeViewModel {
    var arrCategories : CategoryData = CategoryData()
    func loadData() {
        
    }
    
    func loadProductCategories(completion: @escaping (_ status: Bool, _ message: String) -> Void) {
        APIManager.get(params: ["":""], url: APPURL.Urls.Categories, addAccessToken: false) { responseData, error in
            if error == nil {
                print(responseData?.count ?? "No Data Found")
                guard let data = responseData else {
                    completion(false, error ?? "Something went wrong. Please try again.")
                    return
                }
                do {
                    if let dataValue = try? JSONDecoder().decode(CategoryData.self, from: data) {
                        print(dataValue)
                        self.arrCategories = dataValue
                        completion(true, "Got the Data")
                    } else {
                        print("Change in Response Data Structure")
                        completion(false, "Something went wrong. Please try again.")
                    }
                }
                
            } else {
                print(error ?? "Something went wrong")
                completion(false, error ?? "Something went wrong. Please try again.")
            }
        }
    }
    
    
    func getCategoryIdAt(index: Int) -> Int {
        if arrCategories.count > index {
            let category = arrCategories[index]
            return category.id
        }
        return -1
    }
    
    func getCategoryNameAt(index: Int) -> String {
        if arrCategories.count > index {
            let category = arrCategories[index]
            return category.name
        }
        return ""
    }
    
    func getCategoryImageAt(index: Int) -> String {
        if arrCategories.count > index {
            let category = arrCategories[index]
            return category.image
        }
        return ""
    }
}
