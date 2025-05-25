//
//  ProductResponseModel.swift
//  RVCart
//
//  Created by RV on 25/05/25.
//

import Foundation
// MARK: - Product
struct Product: Codable {
    let id: Int
    let title, slug: String
    let price: Int
    let description: String
    let category: CategoryDataValue
    let images: [String]
    let creationAt, updatedAt: String
}

typealias Products = [Product]
