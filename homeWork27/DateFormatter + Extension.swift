//
//  DateFormatter + Extension.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 11.07.22.
//

import Foundation

extension Int {
    func timeDecoder(int: Self, format: String) -> String {
        let date = NSDate(timeIntervalSince1970: TimeInterval(int))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
}
