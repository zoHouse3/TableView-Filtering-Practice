//
//  Route.swift
//  Countries
//
//  Created by Eric Barnes - iOS on 2/14/24.
//

import Foundation

enum Route {
    static let baseUrl = "https://gist.githubusercontent.com"
    
    case allCountries
    
    var path: String {
        switch self {
        case .allCountries:
            return "/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        }
    }
}
