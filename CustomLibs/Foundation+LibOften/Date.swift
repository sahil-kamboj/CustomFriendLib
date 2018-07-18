//
//  Date.swift
//
//  Created by Lakhwinder Singh on 10/05/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit

func getYearsListFomNow() -> [String] {
    let calendar = NSCalendar.current
    let fmt = DateFormatter()
    fmt.dateFormat = "yyyy"
    
    var startDate:Date = fmt.date(from: "2000")!
    let endDate:Date = fmt.date(from: fmt.string(from: Date()))!
    
    var years = [String]()
    while startDate < endDate {
        startDate = calendar.date(byAdding: .year, value: 1, to: startDate)!
        years.append(fmt.string(from: startDate))
    }
    return years.reversed()
}

extension Date {

    func string(_ format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////

/*
 String extension only for date methods
 */
extension String {
    
    func date(_ format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
    
}


