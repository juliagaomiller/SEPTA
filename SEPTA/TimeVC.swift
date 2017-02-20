//
//  TimeVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/16/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class TimeVC: UIViewController {
    
    @IBOutlet var lineNameLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var currentDayLabel: UILabel!
    @IBOutlet var dayOfWeekScheduleLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var stationDetailArray = [StationDetail]()
    var savedStationsDict = [[String:Any]]()
    var weekDayStations = [StationDetail]()
    var switchStationMode = false
//    var currentDisplayedStation: StationDetail!
    var currentDayOfWeek = "weekday"
    var timeIndex = 0

    var stationDetailIndex = 0
    var stationTimes = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if savedStationsDict.count != 0 {
            stationDetailArray.removeAll()
            for x in savedStationsDict {
                let stationDetail = StationDetail(dict: x)
                stationDetailArray.append(stationDetail)
            }
        }
        
        createWeekStations()
        displayCurrentDate()
        displayClosestStation()
    }
    
    func createWeekStations(){
//        var i = 0
        for station in stationDetailArray {
            if currentDayOfWeek == "weekend" {
                if station.dayOfWeekSchedule == "saturday"
                || station.dayOfWeekSchedule == "sunday"
                    || station.dayOfWeekSchedule == "weekend" {
                    weekDayStations.append(station)
                }
            }
            if station.dayOfWeekSchedule == currentDayOfWeek {
                weekDayStations.append(station)
            }
            //check if it is the weekday
        }
    }
    
    func displayCurrentDate(){
        let currentDate = Date()
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        df.amSymbol = "AM"
        df.pmSymbol = "PM"
        let time = df.string(from: currentDate)
        df.dateFormat = "MMM dd, yyyy"
        let weekday = getDayOfWeek(date: currentDate)
        currentDayOfWeek = weekday
        var dateString = df.string(from: currentDate)
        dateString = "\(weekday), \(dateString)"
        currentTimeLabel.text = time
        currentDayLabel.text = dateString
    }
    
    @IBAction func openMenu(){
        //go to all schedules
        //go to my schedules.
        //go to map (interactive in 2.0, or not..might just be too much)
        //send feedback.
    }
    
    @IBAction func switchStations(){
        switchStationMode = true
        tableView.reloadData()
    }
    
    @IBAction func switchDayOfWeekSchedule(){
        
    }
    
    func findClosestStation(){
        //returns StationDetail
    }
    
    func displayClosestStation(){
        findClosestStation()
        //get your location and compare with locations of your favorite stations.
        displayStation(station: stationDetailArray[stationDetailIndex])
    }
    
    func displayStation(station: StationDetail){
        lineNameLabel.text = station.stationName
        directionLabel.text = station.direction
        if station.timesArray.count != 0 {
           stationTimes = station.timesArray
            tableView.reloadData()
            setCorrectTimeIndex()
            //tableView.scrollToRow
//        } else {
//            //haven't filled in the times yet for this station
//            //display a note reminding yourself to log these hours.
//        }
        }
    }
    
    func configureTimeCells(){
        
    }
    
    func setCorrectTimeIndex(){
        let currentTime = Date()
        let df = DateFormatter()
        var i = 0
        for time in stationTimes {
            var currentDay = currentTime.string(format: "MM/dd/yy ")
            currentDay = currentDay + time
            print(currentDay)
            df.dateFormat = "MM/dd/yy hh:mm a"
            let stationTime = df.date(from: currentDay)
            if stationTime == nil {fatalError("stationTime is nil!")}
            let difference = currentTime.minutes(from: stationTime!)
            print("\(time) minutes from now: \(difference)")
            //if i is negative --> this is the closest time, convert the next three cells to time 
            //and find a way to change the cell color in cell for row. 
            i += 1
        }
        
        //return 1
    }
    
    func convertNumberOfMinutesToTimeString(numberOfMinutes minutes: Int) -> String {
        return ""
    }
}

extension TimeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switchStationMode {
            return weekDayStations.count
        } else {
            return stationTimes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if switchStationMode {
            let station = weekDayStations[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeStationCell") as! ChangeStationCell
            cell.configure(stationName: station.stationName, direction: station.direction)
            return cell
        } else {
//            print("station times count:", stationTimes.count)
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
            cell.configure(departureTime: stationTimes[indexPath.row])
            return cell
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if switchStationMode {
            stationDetailIndex = indexPath.row
            displayStation(station: stationDetailArray[stationDetailIndex])
            
        } else {
            //we are on the train times and we can either see how long it will take to get to one of our favorited stations.
            //make an alert view pop up telling distances, or reload tableview. 
            //OR look at apple documentation and remember to try to do the dropdown menu
            
            //or we can set up a notification
            //– but I think we'll make that only possible by pressing the notification button in the cell.
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


