//
//  CountryRepository.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import Foundation

protocol CountryRepositoryProtocol {
  func getLikedCountries() -> [Country]
  func addLikedCountry(country: Country)
  func dislikeCountry(with wikiId: String)
  func getAllCountries(countryModelsFetchHandler: @escaping ([CountryCell.ViewModel]) -> Void)
}

final class CountryRepository: CountryRepositoryProtocol {
  
  // MARK: - Variables
  
  private let localStore: LocalStoreProtocol
  
  // MARK: - Init
  
  init(localStore: LocalStoreProtocol = LocalStore()) {
    self.localStore = localStore
  }
  
  func getLikedCountries() -> [Country] {
    return localStore.retrieveCodable(with: .likedCountries) ?? []
  }
  
  func addLikedCountry(country: Country) {
    var likedCountries = getLikedCountries()
    likedCountries.append(country)
    localStore.storeCodable(with: .likedCountries, value: likedCountries)
  }
  
  func dislikeCountry(with wikiId: String) {
    var likedCountries = getLikedCountries()
    likedCountries.removeAll(where: { $0.wikiDataId == wikiId })
    localStore.storeCodable(with: .likedCountries, value: likedCountries)
  }
  
    
  func getAllCountries(countryModelsFetchHandler: @escaping ([CountryCell.ViewModel]) -> Void) {
    let headers = [
        "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
        "X-RapidAPI-Key": "1ae9acbc28mshe9cc26062efb2dbp18dfe5jsn0934072e482d"
    ]
    let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries?limit=10")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                        timeoutInterval: 60.0)
    request.httpMethod = "GET"
    request.allHTTPHeaderFields = headers

    let session = URLSession.shared
    let dataTask = session.dataTask(
        with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
        if (error != nil) {
            debugPrint(error!)
        } else {
            let apiResponse = try? JSONDecoder().decode(CountryListResponse.self, from: data!)
            let countryList = apiResponse?.data?.map {
                $0.toViewModel()
            } ?? []
            countryModelsFetchHandler(countryList)
        }
    })
    dataTask.resume()
  }
}
