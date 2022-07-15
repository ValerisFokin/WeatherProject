//
//  RealmViewController.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 7.07.22.
//

import UIKit
import RealmSwift

class RealmViewController: UIViewController {

    @IBOutlet weak var realmTableView: UITableView!
    
    var realmForWeatherData: Results<RealmWeatherData>!
    private var manager: WeatherManagerProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = WeatherManager()
        realmTableView.delegate = self
        realmTableView.dataSource = self
        realmForWeatherData = manager.sortedData().sorted(byKeyPath: "time", ascending: false)
        realmTableView.register(UINib(nibName: "RealmTableViewCell", bundle: nil), forCellReuseIdentifier: RealmTableViewCell.key)
        realmTableView.reloadData()
    }

}

extension RealmViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        realmForWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let realmForTableViewCell = realmTableView.dequeueReusableCell(withIdentifier: RealmTableViewCell.key) as? RealmTableViewCell {
            
            let decodedTime = realmForWeatherData[indexPath.row].time.timeDecoder(format: "HH:mm:ss dd MMM YYYY")
            realmForTableViewCell.tempLabel.text = "\(Int(realmForWeatherData[indexPath.row].temp))"
            realmForTableViewCell.feelsLikeLabel.text = "\(Int(realmForWeatherData[indexPath.row].feelsLike))"
            realmForTableViewCell.descriptionLabel.text = "\(realmForWeatherData[indexPath.row].descriptionWeather)"
            
            realmForTableViewCell.timeLabel.text = "\(decodedTime)"
            
            if let latCoord = realmForWeatherData[indexPath.row].coordinate?.lat,
               let lonCoord = realmForWeatherData[indexPath.row].coordinate?.lon {
            realmForTableViewCell.latLabel.text = "\(latCoord)"
            realmForTableViewCell.lonLabel.text = "\(lonCoord)"
            }
            return realmForTableViewCell
        }
        return RealmTableViewCell()
    }
    
    
}

