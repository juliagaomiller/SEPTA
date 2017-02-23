//
//  Helper.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/20/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

var lines = [[String:Any]]()
var favoritedLines = [[String:Any]]()
let revealViewControllerWidth: CGFloat = 250

let lightGreen = UIColor(red:0.40, green:1.00, blue:0.40, alpha:0.3)
let lightLightGreen = UIColor(red:0.40, green:1.00, blue:0.40, alpha:0.2)
let lightLightLightGreen = UIColor(red:0.40, green:1.00, blue:0.40, alpha:0.1)

typealias SelectStation = (line: String, direction: String, stationNamesArray: [[String:Any]])

func getDayOfWeek(date: Date, returnSatSun: Bool)->String {
    let cal = Calendar(identifier: .gregorian)
    let weekday = cal.component(.weekday, from: date)
    switch(weekday){
    case 1:
        if returnSatSun {
            return "sunday"
        } else {
           return "weekend"
        }
    case 2...6:
        return "weekday"
    case 7:
        if returnSatSun {
            return "saturday"
        } else {
           return "weekend"
        }
    default: fatalError("\(weekday)")
    }
}

func calculateTimeInMinutesUntilDepartureTime(departureTime: String)->Int{
    let df = DateFormatter()
    let currentTime = Date()
    let currentDay = currentTime.string(format: "MM/dd/yy")
    let stationTimeString = currentDay + " " + departureTime
    df.dateFormat = "MM/dd/yy hh:mm a"
    let stationTimeDate = df.date(from: stationTimeString)
    guard let _ =  stationTimeDate else {fatalError("stationTime is nil!")}
    let difference = currentTime.minutes(from: stationTimeDate!)
    return difference
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

struct StationDetail {
    var scheduleName: String //e.g. Chestnut Hill West
    var stationName: String //e.g. Allen Lane
    var direction: String //e.g. -> Center City
    var dayOfWeekSchedule: String //e.g. weekday
    var timesArray: [String] // e.g. 5:55 AM, 7:30 AM...
    
    init(scheduleName: String,
         stationName: String,
         direction: String,
         dayOfWeekSchedule: String,
         timesArray: [String]){
        self.scheduleName = scheduleName
        self.stationName = stationName
        self.direction = direction
        self.dayOfWeekSchedule = dayOfWeekSchedule
        self.timesArray = timesArray
    }
    
    public init(dict: [String:Any]){
        scheduleName = dict["scheduleName"] as! String
        stationName = dict["stationName"] as! String
        direction = dict["direction"] as! String
        dayOfWeekSchedule = dict["dayOfWeekSchedule"] as! String
        timesArray = dict["timesArray"] as! [String]
    }
    
    public func encode() -> [String:Any]{
        var dict = [String:Any]()
        dict["scheduleName"] = scheduleName
        dict["stationName"] = stationName
        dict["direction"] = direction
        dict["dayOfWeekSchedule"] = dayOfWeekSchedule
        dict["timesArray"] = timesArray
        return dict
    }
    
}
