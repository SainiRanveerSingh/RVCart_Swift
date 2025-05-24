//
//  LoginResponseModel.swift
//  RVCart
//
//  Created by RV on 24/05/25.
//

import Foundation
// MARK: - LoginResponse
struct LoginResponse: Codable {
    let accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

// MARK: - FailureResponse
struct FailureResponse: Codable {
    let message: String
    let statusCode: Int
}

