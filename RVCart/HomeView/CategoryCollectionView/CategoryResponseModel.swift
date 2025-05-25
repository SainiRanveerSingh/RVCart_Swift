//
//  CategoryResponseModel.swift
//  RVCart
//
//  Created by RV on 25/05/25.
//

import Foundation
// MARK: - CategoryDataValue
struct CategoryDataValue: Codable {
    let id: Int
    let name, slug: String
    let image: String
    let creationAt, updatedAt: String
}

typealias CategoryData = [CategoryDataValue]
