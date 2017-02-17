//
//  StationsVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/15/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

struct StationDetail {
    var scheduleName: String //e.g. Chestnut Hill West
    var stationName: String //e.g. Allen Lane
    var direction: String //e.g. to Center City
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
    
}

typealias StationTuple = (name: String, bothDirections: [[String:Any]])
typealias DirectionTuple = (scheduleName: String, directionName: String, stationTimes: [[String:Any]])
typealias SelectStation = (line: String, direction: String, stationNamesArray: [[String:Any]])
//typealias StationSchedule = (stationName: String, hours: [[String:Any]])

class StationsVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var directionLabel: UILabel!
    
    var stationTupleArray = [StationTuple]()
    var directionTupleArray = [DirectionTuple]()
    
    var selectStationIndex = 0
    var stationArray = [SelectStation]()
    var selectedStationsArray = [SelectStation]()
    var stationDetailArray = [StationDetail]()
    
    var selectedLines = [[String:Any]]()
    
//    var selectedStations = [[String:Any]]()
//    var stationDetailArray = [StationDetail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getStationsForEachLine()
        updateHeader()
        //createStationDetails()
    }
    
    func createStationDetail(station: SelectStation, index: Int){
        let scheduleName = station.line
        let direction = station.direction
        
        let stationName = (station.stationNamesArray[index]["name"] as! String)
        let specificStation = station.stationNamesArray[index]
        var weekHours = station.stationNamesArray[index]
        weekHours.removeValue(forKey: "name")
        for schedule in weekHours {
            print(schedule)
            //WORKS!!
//            let scheduleDetail = StationDetail(scheduleName: scheduleName, stationName: stationName, direction: direction, dayOfWeekSchedule: schedule["name"], timesArray: <#T##[String]#>)
        }
        
        //let stationSchedule = StationSchedule(stationName: stationName, hours: )
    }
    
    @IBAction func next(){
        let cells = tableView.visibleCells
        for cell in cells {
            if cell.accessoryType != .none {
                let stationCell = cell as! StationCell
                createStationDetail(station: stationCell.station, index: stationCell.index)
            }
            cell.accessoryType = .none
        }
        if selectStationIndex < stationArray.count {
            selectStationIndex += 1
            updateHeader()
            
            tableView.reloadData()
        } else {
            //perform segue to TimeVC
        }
    }
    
    func updateHeader(){
        directionLabel.text = stationArray[selectStationIndex].direction
    }
    
    func getStationsForEachLine(){
        
        for line in selectedLines {
            let lineName = line["name"] as! String
            let directions = line["directions"] as! [[String:Any]]
            for x in directions {
                let directionName = x["name"] as! String
                let allStations = x["stations"] as! [[String:Any]]
//                var stationNamesArray = [String]()
//                for station in allStations {
//                    let stationName = station["name"] as! String
//                    stationNamesArray.append(stationName)
//                }
                stationArray.append((line: lineName, direction: directionName, stationNamesArray: allStations))
            }
//            stationTupleArray.append((name: lineName, bothDirections: directions))
        }
//        for tuple in stationTupleArray {
//            let array = tuple.bothDirections
//            for direction in array {
//                let name = direction["name"] as! String
//                let stations = direction["stations"] as! [[String : Any] ]
//                directionTupleArray.append((scheduleName: tuple.name,
//                                            directionName: name,
//                                            stationTimes: stations))
//            }
//        }
    }

//    func createStationDetails(){
//
//        for station in directionTupleArray {
//            let scheduleName = station.scheduleName
//            for stationTime in station.stationTimes {
//                let stationName = stationTime["name"] as! String
//                let weekday = stationTime["weekday"] as! [String]
//                let stationDetail = StationDetail(scheduleName: scheduleName,
//                                                  stationName: stationName,
//                                                  direction: station.directionName,
//                                                  dayOfWeekSchedule: "weekday",
//                                                  timesArray: weekday)
//                stationDetailArray.append(stationDetail)
//                if let sunday = stationTime["sunday"] as? [String] {
//                    let newStationDetail = StationDetail(scheduleName: scheduleName,
//                                                      stationName: stationName,
//                                                      direction: station.directionName,
//                                                      dayOfWeekSchedule: "sunday",
//                                                      timesArray: sunday)
//                    stationDetailArray.append(newStationDetail)
//                }
//                if let saturday = stationTime["saturday"] as? [String] {
//                    let newStationDetail = StationDetail(scheduleName: scheduleName,
//                                                         stationName: stationName,
//                                                         direction: station.directionName,
//                                                         dayOfWeekSchedule: "saturday",
//                                                         timesArray: saturday)
//                    stationDetailArray.append(newStationDetail)
//                }
//                
//                if let weekend = stationTime["weekend"] as? [String] {
//                    let newStationDetail = StationDetail(scheduleName: scheduleName,
//                                                         stationName: stationName,
//                                                         direction: station.directionName,
//                                                         dayOfWeekSchedule: "weekend",
//                                                         timesArray: weekend)
//                    stationDetailArray.append(newStationDetail)
//                }
//                
//            }
//            
//        }
//    }
}

extension StationsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArray[selectStationIndex].stationNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell") as! StationCell
//        let stationDetails = (stationArray[selectStationIndex].stationNamesArray[indexPath.row])
//        //name, weekday
//        cell. = station
        let station = stationArray[selectStationIndex].stationNamesArray[indexPath.row]
        cell.stationLabel.text = (station["name"] as! String)
        cell.station = stationArray[selectStationIndex]
        cell.index = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


