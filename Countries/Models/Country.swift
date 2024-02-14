//
//  Country.swift
//  Countries
//
//  Created by Eric Barnes - iOS on 2/14/24.
//

import Foundation

struct Country: Decodable {
    let name: String
    let region: String
    let capital: String
    let code: String
    
    var nameRegionText: String {
        return "\(name), \(region)"
    }
}
