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
    
//    // Decode
//    public init(dictionary: Dictionary<String, AnyObject>){
//        name = dictionary["name"] as? String
//        amount = dictionary["amount"] as? Int
//    }
//    
//    // Encode
//    public func encode() -> Dictionary<String, AnyObject> {
//        
//        var dictionary : Dictionary = Dictionary<String, AnyObject>()
//        dictionary["name"] = name
//        dictionary["amount"] = amount
//        return dictionary
//    }
    
}

typealias DirectionTuple = (scheduleName: String, directionName: String, stationTimes: [[String:Any]])
typealias SelectStation = (line: String, direction: String, stationNamesArray: [[String:Any]])

class StationsVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var directionLabel: UILabel!
    
    var selectStationIndex = 0
    var stationArray = [SelectStation]()
//    var selectedStationsArray = [SelectStation]()
    var stationDetailArray = [StationDetail]()
    
    var selectedLines = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getStationsForEachLine()
        updateHeader()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! TimeVC
        var dictionary = [[String:Any]]()
        for x in stationDetailArray {
            let data = x.encode()
            dictionary.append(data)
        }
        UserDefaults.standard.set(dictionary, forKey: "stationDetailArray")
        vc.stationDetailArray = stationDetailArray
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
        selectStationIndex += 1
        if selectStationIndex < stationArray.count {
            updateHeader()
            tableView.reloadData()
        } else {
            performSegue(withIdentifier: "TimeVC", sender: nil)
        }
    }
}

extension StationsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationArray[selectStationIndex].stationNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationCell") as! StationCell
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

extension StationsVC {
    func updateHeader(){
        if selectStationIndex < stationArray.count {
            directionLabel.text = stationArray[selectStationIndex].direction
        }
    }
    
    func getStationsForEachLine(){
        
        for line in selectedLines {
            let lineName = line["name"] as! String
            let directions = line["directions"] as! [[String:Any]]
            for x in directions {
                let directionName = x["name"] as! String
                let allStations = x["stations"] as! [[String:Any]]
                stationArray.append((line: lineName, direction: directionName, stationNamesArray: allStations))
            }
        }
    }
    
    func createStationDetail(station: SelectStation, index: Int){
        let scheduleName = station.line
        let direction = station.direction
        
        let stationName = (station.stationNamesArray[index]["name"] as! String)
        var weekHours = station.stationNamesArray[index]
        weekHours.removeValue(forKey: "name")
        for schedule in weekHours {
            let dayOfWeekSchedule = schedule.key
            var stationDetail: StationDetail!
            guard let timesArray = schedule.value as? [String] else {
                stationDetail = StationDetail(scheduleName: scheduleName, stationName: stationName, direction: direction, dayOfWeekSchedule: dayOfWeekSchedule, timesArray: [""])
                break
            }
            stationDetail = StationDetail(scheduleName: scheduleName, stationName: stationName, direction: direction, dayOfWeekSchedule: dayOfWeekSchedule, timesArray: timesArray)
            stationDetailArray.append(stationDetail)
        }
    }
}


