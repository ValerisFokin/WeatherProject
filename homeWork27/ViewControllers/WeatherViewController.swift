//
//  ViewController.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 28.06.22.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var discriptionLabel: UILabel!
    
    @IBOutlet weak var hourlyTempCollection: UICollectionView!
    
    @IBOutlet weak var dailyTempTable: UITableView!
    
    private var apiProvider: RestAPIProviderProtocol!
    
    var dailyWeatherArray: [DailyWeatherData] = []
    var hourlyWeatherArray: [HourlyWeatherData] = []
    private var manager: WeatherManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiProvider = AlamofireProvider()
        getCoordByCityName()
        
        cityLabel.text = ""
        tempLabel.text = ""
        feelsLikeLabel.text = ""
        discriptionLabel.text = ""
        
        dailyTempTable.delegate = self
        dailyTempTable.dataSource = self
        
        hourlyTempCollection.delegate = self
        hourlyTempCollection.dataSource = self
        
        manager = WeatherManager()
        
        dailyTempTable.register(UINib(nibName: "DailyWeatherCell", bundle: nil), forCellReuseIdentifier: DailyWeatherCell.key)
        hourlyTempCollection.register(UINib(nibName: "HourlyWeatherCell", bundle: nil), forCellWithReuseIdentifier: HourlyWeatherCell.key)
     
    }
    
    func getCoordByCityName() {
        apiProvider.getCoordinatesByCityName(name: "Minsk") { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                if let city = value.first {
                    self.getWeatherByCoordinates(city: city)
                    DispatchQueue.main.async {
                        self.cityLabel.text = city.cityName
                    }
                    
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getWeatherByCoordinates(city: Geocoding) {
        apiProvider.getWeatherForCityCoordinates(lat: city.lat, lon: city.lon) { [weak self]  result in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                guard let weatherIconId = value.current?.weather?.first?.icon else {return}
                
                DispatchQueue.main.async {
                    
                    guard let lonData = value.lon,
                          let latData = value.lat
                    else {return}
                    let date = Date()
                    let coordinatesRealmData = RealmData()
                    coordinatesRealmData.lat = latData
                    coordinatesRealmData.lon = lonData
                    coordinatesRealmData.time = Int(date.timeIntervalSince1970)
                    
                    self.manager.coordinates(coordinatesData: coordinatesRealmData)
                   
                    guard let tempData = value.current?.temp,
                          let feelsLikeData = value.current?.feelsLike,
                          let descriptionData = value.current?.weather?.first?.description
                    else {return}
                    
                    let weatherRealmData = RealmWeatherData()
                    weatherRealmData.temp = tempData
                    weatherRealmData.feelsLike = feelsLikeData
                    weatherRealmData.descriptionWeather = descriptionData
                    weatherRealmData.time = Int(date.timeIntervalSince1970)
                    weatherRealmData.coordinate = coordinatesRealmData
                    
                    self.manager.weather(weatherData: weatherRealmData)
                    
                    
                    if let hourly = value.hourly {
                        self.hourlyWeatherArray = hourly
                    }
                    if let daily = value.daily {
                        self.dailyWeatherArray = daily
                    }
                    guard let temp = value.current?.temp else {return}
                    
                    self.tempLabel.text = "температура воздуха +\(Int(temp))"
                    
                    guard let feelsLikeTemp = value.current?.feelsLike else {return}
                    self.feelsLikeLabel.text = "ощущается как +\(Int(feelsLikeTemp))"
                    
                    guard let descriptionWeather = value.current?.weather?.first?.description else {return}
                    self.discriptionLabel.text = descriptionWeather
                    
                    guard let imageUrl = URL(string: "\(Constants.imageURL)\(weatherIconId)@2x.png") else {return}
                    if let data = try? Data(contentsOf: imageUrl) {
                        self.weatherImage.image = UIImage(data: data)
                        
                    }
                    
                    self.hourlyTempCollection.reloadData()
                    self.dailyTempTable.reloadData()
                    print(value)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}


extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyWeatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let collectionCell = hourlyTempCollection.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCell.key, for: indexPath) as? HourlyWeatherCell {
            
            if let hourlyTemp = hourlyWeatherArray[indexPath.row].temp,
               let hourlyIconId = hourlyWeatherArray[indexPath.row].weather?.first?.icon,
               let imageUrl = URL(string: "\(Constants.imageURL)\(hourlyIconId)@2x.png"),
               let data = try? Data(contentsOf: imageUrl) {
                
                collectionCell.hourlyWeatherLabel.text = "+\(Int(hourlyTemp))"
                collectionCell.hourlyWeatherImage.image = UIImage(data: data)
            }
            
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dailyCell = dailyTempTable.dequeueReusableCell(withIdentifier: DailyWeatherCell.key) as? DailyWeatherCell {
            
            if let dailyWeatherDay = dailyWeatherArray[indexPath.row].dt,
               let dailyWeatherMax = dailyWeatherArray[indexPath.row].temp?.max {
                
                let decodedDay = dailyWeatherDay.timeDecoder( format: "dd MMM YYYY")
                dailyCell.dayLabel.text = decodedDay
                dailyCell.weatherLabel.text = "+\(Int(dailyWeatherMax))"
            }
            return dailyCell
        }
        return UITableViewCell()
    }
    
}





