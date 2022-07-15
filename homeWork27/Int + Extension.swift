//
//  DateFormatter + Extension.swift
//  homeWork27
//
//  Created by Валерий Вергейчик on 11.07.22.
//

import Foundation

extension Int {
    func timeDecoder(format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        return dayTimePeriodFormatter.string(from: date as Date)
        
    }
}
