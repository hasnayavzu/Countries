//
//  DetailsVC.swift
//  Countries
//
//  Created by Hasan Yavuz on 9.04.2022.
//

import Foundation
import UIKit
import Kingfisher
import CoreMedia

class DetailsVC: UIViewController {
    
    @IBOutlet weak var CountryCodeLabel: UILabel!
    @IBOutlet weak var CountryFlagImage: UIImageView!
    
    var wikiDataId: String?
    var flag: String?
    
    init?(wikiDataId: String?, coder: NSCoder) {
        self.wikiDataId = wikiDataId
        super.init(coder: coder)
    }
    
    init(with wikiDataId: String?) {
        self.wikiDataId = wikiDataId
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.wikiDataId = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCountryDetails(wikiDataId: wikiDataId ?? "")
        
    }
    
    @IBAction func moreInfoButton(_ sender: UIButton) {
        guard let wikiId = wikiDataId else { return }
        UIApplication.shared.open(URL(string: "https://www.wikidata.org/wiki/\(wikiId)")!,  options: [:], completionHandler: nil)
    }
    
    func populate(with countryDetail: CountryDetail?) {
        CountryCodeLabel.text = countryDetail?.code
        self.flag = (countryDetail?.flagImageUri)!
        let url = URL(string: flag!)
        let data = try? Data(contentsOf: url!)
        print(data as Any)
        print(countryDetail?.flagImageUri as Any)
        print(flag as Any)
    }
    
    func getAllCountryDetails(wikiDataId:String) {
        let headers = [
          "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com",
          "X-RapidAPI-Key": "1ae9acbc28mshe9cc26062efb2dbp18dfe5jsn0934072e482d"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/countries/\(wikiDataId)")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(
          with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
          if (error != nil) {
              debugPrint(error!)
          } else {
              let apiResponse = try? JSONDecoder().decode(CountryDetailResponse.self, from: data!)
              let countryDetail = apiResponse?.data
              DispatchQueue.main.async { [self] in
                  self?.populate(with: countryDetail)
                  self?.CountryFlagImage.image = UIImage(data: data!)
              }
          }
        })
        dataTask.resume()
    }
    
    
    
}
