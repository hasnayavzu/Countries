//
//  Country.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import Foundation

struct CountryListResponse: Codable {
    var data: [Country]?
}

struct Country: Codable {
    var code: String?
    var currencyCodes: [String]?
    var name: String?
    var wikiDataId: String?
}

extension Country {
    
    func toViewModel() -> CountryCell.ViewModel {
        let viewModel = CountryCell.ViewModel()
        viewModel.name = name
        viewModel.wikiDataId = wikiDataId
        return viewModel
    }
    
}
