//
//  HomeViewModel.swift
//  RVCart
//
//  Created by RV on 24/05/25.
//

import Foundation
final class HomeViewModel {
    var arrCategories : CategoryData = CategoryData()
    var arrProducts : Products = Products()
    var selectedCategoryId = -1
    var offsetValue = 0
    var limitValue = 10 //default limit is of 10. Change as per requirement.
    var isMoreDataAvailable = true
    var minimumSelectedPrice = 1
    var maximumSelectedPrice = 1000
    
    //MARK: -- Category API --
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
    
    func logOutUser() {
        do {
            try? KeychainSecure.instance.saveToken("", forKey: "accessToken")
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
    
    //MARK: -- Product API --
    func loadProductData(completion: @escaping (_ status: Bool, _ message: String) -> Void) {
        
        //Setting up parameter for pagination
        //offset=0&limit=10
        var param = [String:String]()
        param.updateValue("\(offsetValue)", forKey: "offset")
        param.updateValue("\(limitValue)", forKey: "limit")
        
        //Setting up param eter for Price range
        //price_min=900&price_max=1000
        param.updateValue("\(minimumSelectedPrice)", forKey: "price_min")
        param.updateValue("\(maximumSelectedPrice)", forKey: "price_max")
        
        if selectedCategoryId != -1 {
            param.updateValue("\(selectedCategoryId)", forKey: "categoryId")
        }
        
        APIManager.get(params: param, url: APPURL.Urls.Products, addAccessToken: false) { responseData, error in
            if error == nil {
                print(responseData?.count ?? "No Data Found")
                guard let data = responseData else {
                    completion(false, error ?? "Something went wrong. Please try again.")
                    return
                }
                do {
                    if let dataValue = try? JSONDecoder().decode(Products.self, from: data) {
                        //print(dataValue)
                        if self.offsetValue == 0 {
                            self.arrProducts = dataValue
                        } else {
                            if dataValue.count == 0 {
                                //No more data available to load
                                self.isMoreDataAvailable = false
                            } else {
                                self.arrProducts.append(contentsOf: dataValue)
                            }
                        }
                        //TODO: -- Testing --
                        //The response data array values are getting change and sometimes getting 0 Products in Array
                        /*
                        if dataValue.count == 1 {
                            self.arrProducts.append(dataValue.first!)
                        }
                        */
                        if dataValue.count == 0 {
                            if self.offsetValue == 0 {
                                completion(true, "There are no products available in the category you have selected.")
                            } else {
                                completion(true, "No more products available to show.")
                            }
                        } else {
                            completion(true, "Got the Data")
                        }
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
}
