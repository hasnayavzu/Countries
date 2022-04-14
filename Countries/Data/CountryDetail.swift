//
//  CountryDetail.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import Foundation

struct CountryDetailResponse: Codable {
    var data: CountryDetail?
}

struct CountryDetail: Codable {
    var code: String?
    var flagImageUri: String?
    var name: String?
    var wikiDataId: String?
}
