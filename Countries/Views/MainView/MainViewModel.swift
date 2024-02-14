//
//  MainViewModel.swift
//  Countries
//
//  Created by Eric Barnes - iOS on 2/14/24.
//

import Foundation

class MainViewModel {
    @Published var isDoneLoadingData: Bool = false
    var allCountries: [Country] = []
    var filteredCountries: [Country] = []
    
    func getCountries() {
        NetworkingManager.shared.fetchAllCountries { [weak self] result in
            switch result {
            case .success(let countries):
                self?.allCountries = countries
                self?.filteredCountries = self?.allCountries ?? []
            case .failure(let error):
                fatalError("COULD NOT FETCH COUNTRIES: \(error.localizedDescription)")
            }
            self?.isDoneLoadingData = true
        }
    }
}
