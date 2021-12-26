//
//  DateExtension.swift
//  NextTrain
//
//  Created by WOO Yu Kit Vincent on 23/12/2021.
//

import Foundation

extension String {
    var timeString: String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatterGet.date(from: self) {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "h:mm"
            return dateFormatterPrint.string(from: date)
        } else {
            return ""
        }
    }
}
