//
//  AppError.swift
//  Countries
//
//  Created by Eric Barnes - iOS on 2/14/24.
//

import Foundation

enum NetworkingError: LocalizedError {
    case errorDecoding
    case invalidRequest
    case invalidUrl
    case serverError(String)
    case noData
    case unknownError
}
