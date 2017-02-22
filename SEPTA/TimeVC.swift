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
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var savedStationsDict = [[String:Any]]()
    
    var currentStation: StationDetail!
    var stationTimes: [String: [String]] = ["":[""]]
    
    
    var stationDetailArray = [StationDetail]()
    var weekDayStations = [StationDetail]()
    
    var stationSchedules = [StationDetail]()
    
    var currentDayOfWeek = ""
    
    var timeIndex = 0
    var stationDetailIndex = 0
    //    var dayOfWeekIndex = 0
    
    var switchStationMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRailLines()
        tableView.delegate = self
        tableView.dataSource = self
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().rearViewRevealWidth = revealViewControllerWidth
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForUserDefaults()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StationsVC" {
            let vc = segue.destination as! StationsVC
            vc.selectedLines = sender as! [[String:Any]]
        }
    }
    
    @IBAction func switchWeekSchedules(){
        switch(currentDayOfWeek){
        case "weekday":
            if stationSchedules.count == 2 {
                currentDayOfWeek = "weekend"
            } else if stationSchedules.count == 3 {
                currentDayOfWeek = "saturday"
            }
        case "weekend":
            currentDayOfWeek = "weekday"
        case "saturday":
            currentDayOfWeek = "sunday"
        case "sunday":
            currentDayOfWeek = "weekday"
        default:
            fatalError("\(currentDayOfWeek)")
        }
        tableView.reloadData()
    }
    
    @IBAction func switchStations(){
        switchStationMode = true
        displayStation(stationName: currentStation.stationName,
                       direction: currentStation.direction)
        reloadView()
        tableView.reloadData()
    }
    
}

extension TimeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if switchStationMode {
            return weekDayStations.count
        } else {
            if stationTimes[currentDayOfWeek]!.count == 1 {
                return 0
            } else {
                return stationTimes[currentDayOfWeek]!.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if switchStationMode {
            let station = weekDayStations[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeStationCell") as! ChangeStationCell
            cell.configure(stationName: station.stationName, direction: station.direction)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
            cell.backgroundColor = UIColor.white
            cell.countdownTimeLabel.font = UIFont.systemFont(ofSize: 12)
            cell.configure(departureTime: stationTimes[currentDayOfWeek]![indexPath.row])
            if indexPath.row == timeIndex {
                cell.backgroundColor = lightGreen
                cell.countdownTimeLabel.font = UIFont.systemFont(ofSize: 18)
            } else if timeIndex < stationTimes[currentDayOfWeek]!.count - 2 && indexPath.row == timeIndex + 1 {
                cell.countdownTimeLabel.font = UIFont.systemFont(ofSize: 16)
                cell.backgroundColor = lightLightLightGreen
            }
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if switchStationMode {
            switchStationMode = false
            let cell = tableView.cellForRow(at: indexPath) as! ChangeStationCell
            let station = cell.stationNameLabel.text
            let direction = cell.directionLabel.text
            for x in weekDayStations {
                if x.stationName == station && x.direction == direction {
                    displayStation(stationName: x.stationName, direction: x.direction)
                    reloadView()
                }
            }
            
        } else {
            //we are on the train times and we can either see how long it will take to get to one of our favorited stations.
            //make an alert view pop up telling distances, or reload tableview.
            //OR look at apple documentation and remember to try to do the dropdown menu
            
            //or we can set up a notification
            //– but I think we'll make that only possible by pressing the notification button in the cell.
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
        
    }
}

extension TimeVC {
    
    func checkForUserDefaults(){
        if let stationsExist = UserDefaults.standard.object(forKey: "stationDetailArray") as? [[String:Any]] {
            savedStationsDict.removeAll()
            savedStationsDict = stationsExist
            checkForSavedStations()
            //            createWeekStations(dayOfWeek: currentDayOfWeek)
            displayCurrentDate()
            displayClosestStation()
            //            self.view.isHidden = false
        } else if let linesExist = UserDefaults.standard.object(forKey: "selectedLines") as? [[String:Any]] {
            performSegue(withIdentifier: "StationsVC", sender: linesExist)
        } else {
            performSegue(withIdentifier: "SchedulesVC", sender: nil)
        }
        
    }
    
    func loadRailLines(){
        if let path = Bundle.main.path(forResource: "septa", ofType: "json") {
            if let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe){
                if let data = try? JSONSerialization.jsonObject(with: json)
                {
                    if let all = data as? [String:Any] {
                        lines = all["lines"] as! [[String:Any]]
                    }
                } else { print("Couldn't convert file from JSON data to Any. Check your JSON file for errors.") }
            }
        }
    }
    
    func reloadView(){
        if switchStationMode {
            dayOfWeekScheduleLabel.isHidden = true
            directionLabel.isHidden = true
            lineNameLabel.text = "Switch Stations"
        } else {
            dayOfWeekScheduleLabel.isHidden = false
            directionLabel.isHidden = false
        }
    }
    
    //    func createWeekStations(dayOfWeek: String){
    //        for station in stationDetailArray {
    //            if dayOfWeek == "weekend" {
    //                if station.dayOfWeekSchedule == "saturday"
    //                    || station.dayOfWeekSchedule == "sunday"
    //                    || station.dayOfWeekSchedule == "weekend" {
    //                    weekDayStations.append(station)
    //                }
    //            } else {
    //                if station.dayOfWeekSchedule == dayOfWeek {
    //                    weekDayStations.append(station)
    //                }
    //            }
    //        }
    //        weekDayStations = weekDayStations.sorted{$0.stationName < $1.stationName}
    //    }
    func findClosestStation(){
        //returns a StationDetail
    }
    
    func displayClosestStation(){
        findClosestStation() // returns a string
        
        let station = stationDetailArray[0]
        displayStation(stationName: station.stationName, direction: station.direction)
    }
    
    func displayStation(stationName: String, direction: String){
        
        var station: StationDetail?
        var timeArray: [String] = []
        
        stationSchedules.removeAll()
        for s in stationDetailArray {
            print(s.stationName, s.direction, s.dayOfWeekSchedule)
            print(stationDetailArray.count)
            if s.direction == direction && s.stationName == stationName {
                print(s.direction)
                stationSchedules.append(s)
            }
        }
        if currentDayOfWeek == "" {
            let today = Date()
            if stationSchedules.count == 2 {
                currentDayOfWeek = getDayOfWeek(date: today, returnSatSun: false)
                
            } else if stationSchedules.count == 3 {
                currentDayOfWeek = getDayOfWeek(date: today, returnSatSun: true)
            } else {
                fatalError("\(stationSchedules.count)")
            }
        }
        
        
        for s in stationSchedules {
            if s.dayOfWeekSchedule == currentDayOfWeek {
                station = s
                timeArray = s.timesArray
                
            }
        }
        
        if station!.timesArray.count != 0 {
            stationTimes = [currentDayOfWeek: timeArray]
            tableView.reloadData()
            setCorrectTimeIndex()
        }
        
        lineNameLabel.text = station!.stationName
        directionLabel.text = station!.direction
    }
    
    func checkForSavedStations(){
        if savedStationsDict.count != 0 {
            stationDetailArray.removeAll()
            for x in savedStationsDict {
                let stationDetail = StationDetail(dict: x)
                stationDetailArray.append(stationDetail)
            }
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
        //        let weekday = getDayOfWeek(date: currentDate)
        //        currentDayOfWeek = weekday
        let dateString = df.string(from: currentDate)
        currentTimeLabel.text = time
        currentDayLabel.text = dateString
    }
    
    func setCorrectTimeIndex(){
        var i = 0
        var previousDifferenceWasPositive = true
        for time in stationTimes[currentDayOfWeek]! {
            let difference = calculateTimeInMinutesUntilDepartureTime(hhmm: time)
            
            if difference < 0 && previousDifferenceWasPositive {
                timeIndex = i
                previousDifferenceWasPositive = false
                tableView.scrollToRow(at: IndexPath.init(row: timeIndex, section: 0), at: .top, animated: false)
            }
            i += 1
        }
        
    }
}


