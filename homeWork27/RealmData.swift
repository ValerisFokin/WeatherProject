//
//  RealmData.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 7.07.22.
//

import Foundation
import RealmSwift

class RealmData: Object {
    @objc dynamic var lon: Double = 0
    @objc dynamic var lat: Double = 0
    @objc dynamic var time: Int = 0
    
}

class RealmWeatherData: Object {
    @objc dynamic var temp: Double = 0
    @objc dynamic var feelsLike: Double = 0
    @objc dynamic var descriptionWeather: String = ""
    @objc dynamic var time: Int = 0
    @objc dynamic var coordinate: RealmData?
}
