//
//  Manager.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 13.07.22.
//

import Foundation
import RealmSwift

protocol ManagerProtocol {
    func coordinates(coordinatesData: RealmData)
    func weather(weatherData: RealmWeatherData)
}

class WeatherManager: ManagerProtocol {
    
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
    
    
}
