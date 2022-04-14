//
//  CountryListDataSource.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import Foundation
import UIKit

final class CountryListDataSource: NSObject {
    
    // MARK: - Variables
    
    private var countryList: [CountryCell.ViewModel] = []
    
    // MARK: - Handlers
    
    var countryLikedHandler: ((CountryCell.ViewModel) -> ())?
    var countrySelectionHandler: ((CountryCell.ViewModel) -> ())?
    
    // MARK: - Methods
    
    func setCountryList(_ models: [CountryCell.ViewModel]) {
        self.countryList = models
    }
}

// MARK: - UITableViewDataSource

extension CountryListDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if countryList.isEmpty {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CountryCell",
            for: indexPath
        ) as! CountryCell
        let countryViewModel = countryList[indexPath.row]
        countryViewModel.onFavoriteTapped = { [weak self] liked in
            countryViewModel.isLiked = !liked
            self?.countryLikedHandler?(countryViewModel)
            cell.configure(with: countryViewModel)
        }
        cell.configure(with: countryViewModel)
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension CountryListDataSource: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = countryList[indexPath.row]
        countrySelectionHandler?(country)
    }
    
}
