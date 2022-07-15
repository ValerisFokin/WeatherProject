//
//  Manager.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 13.07.22.
//

import Foundation
import RealmSwift

protocol WeatherManagerProtocol {
    
    func coordinates(coordinatesData: RealmData)
    func weather(weatherData: RealmWeatherData)
    func sortedData() -> Results<RealmWeatherData>
}

class WeatherManager: WeatherManagerProtocol {
    
    let realm = try! Realm()
    
    
    
    func coordinates(coordinatesData: RealmData) {
        try! realm.write {
            realm.add(coordinatesData)
        }
    }
    
    func weather(weatherData: RealmWeatherData) {
        try! realm.write {
            realm.add(weatherData)
        }
    }
    
    func sortedData() -> Results<RealmWeatherData> {
        return realm.objects(RealmWeatherData.self)
    }
    
    
    
}
