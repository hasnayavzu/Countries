//
//  CountryCell.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import UIKit

class CountryCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var savedButton: UIButton!
    
    final class ViewModel {
        var name: String?
        var wikiDataId: String?
        var isLiked: Bool = false
        var onFavoriteTapped: ((Bool) -> Void)?
    }
    
    private lazy var viewModel = ViewModel()
        
    func configure(with viewModel: ViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        let buttonImage = viewModel.isLiked ?
            UIImage(systemName: "star.fill") :
            UIImage(systemName: "star")
        savedButton.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func onSavedButton(_ sender: Any) {
        viewModel.onFavoriteTapped?(viewModel.isLiked)
    }
    
}

extension CountryCell.ViewModel {
    
    func asCountry() -> Country {
        Country(
            code: nil,
            currencyCodes: nil,
            name: name,
            wikiDataId: wikiDataId
        )
    }
    
}
