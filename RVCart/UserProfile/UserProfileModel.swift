//
//  UserProfileModel.swift
//  RVCart
//
//  Created by RV on 24/05/25.
//

import Foundation

// MARK: - UserProfileModel
struct UserProfileModel: Codable {
    let id: Int
    let email, creationAt, updatedAt, password: String
    let name, role: String
    let avatar: String
}
