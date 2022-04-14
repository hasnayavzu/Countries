//
//  ViewController.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import UIKit

class HomeVC: UIViewController {
    
    private var countryList: [CountryCell.ViewModel] = []
    private var savedCountries: [Country] = []
    private let dataSource = CountryListDataSource()
    private let countryRepository = CountryRepository()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CountryCell", bundle: nil), forCellReuseIdentifier: "CountryCell")
        tableView.delegate = dataSource
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        title = "Countries"
        getCountries()
        bindLikedHandler()
        bindSelectionHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLikedCountries()
    }
    
    func bindLikedHandler() {
        dataSource.countryLikedHandler = { [weak self] countryViewModel in
            let liked = countryViewModel.isLiked
            if liked {
                self?.countryRepository.addLikedCountry(
                    country: countryViewModel.asCountry()
                )
            } else {
                guard let wikiDataId = countryViewModel.wikiDataId else { return }
                self?.countryRepository.dislikeCountry(with: wikiDataId)
            }
        }
    }
    
    func bindSelectionHandler() {
        dataSource.countrySelectionHandler = { [weak self] countryViewModel in
            let wikiId = countryViewModel.wikiDataId
            guard let detailViewController = self?.storyboard?.instantiateViewController(identifier: "DetailsVC", creator: { coder in
                DetailsVC(wikiDataId: wikiId, coder: coder)
            }) else { return }
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
    func mapLikedCountries() {
        savedCountries = countryRepository.getLikedCountries()
        let likedWikiIds = savedCountries.map { $0.wikiDataId }
        countryList.forEach { countryViewModel in
            countryViewModel.isLiked = likedWikiIds.contains(countryViewModel.wikiDataId)
        }
    }
    
    func setupLikedCountries() {
        mapLikedCountries()
        dataSource.setCountryList(countryList)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getCountries() {
        countryRepository.getAllCountries { [weak self] countryList in
            guard let self = self else { return }
            self.countryList = countryList
            self.setupLikedCountries()
        }
        
    }


}

