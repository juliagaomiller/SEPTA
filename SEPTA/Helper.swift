//
//  Helper.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/20/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import Foundation

func getDayOfWeek(date: Date)->String {
    let cal = Calendar(identifier: .gregorian)
    let weekday = cal.component(.weekday, from: date)
    switch(weekday){
    case 1:
        return "weekend"
    case 2...6:
        return "weekday"
    case 7:
        return "weekend"
    default: fatalError("\(weekday)")
    }
}

extension Date {
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func string(format: String) -> String{
        let df = DateFormatter()
        df.dateFormat = format
        let string = df.string(from: self)
        return string
    }
}
