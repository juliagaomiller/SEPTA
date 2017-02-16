//
//  StationsVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/15/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

struct StationDetails {
    
}

class StationsVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var selectedLines = [[String:Any]]()
    var stationDetailsArray = [StationDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        createListOfStations()
    }
    
    typealias StationTuple = (name: String, bothDirections: [[String:Any]])
    typealias DirectionTuple = (scheduleName: String, directionName: String, stationTimes: [[String:Any]])
    typealias StationDetails = (
        scheduleName: String, //e.g. Chestnut Hill West
        stationName: String, //e.g. Allen Lane
        direction: String, // e.g. to Center City
        dayOfWeekSchedule: String, //e.g. weekday
        timesArray: [String]) //5:55 AM, 7:30 AM...
    
    func createListOfStations(){
        var stationTupleArray = [StationTuple]()
        var directionTupleArray = [DirectionTuple]()
        
        //var station: (name: String, bothDirections: [[String:Any]]) = []
        for line in selectedLines {
            let lineName = line["name"] as! String
            let bothDirections = line["directions"] as! [[String:Any]]
            stationTupleArray.append((name: lineName, bothDirections: bothDirections))
        }
        for tuple in stationTupleArray {
            let array = tuple.bothDirections
            for direction in array {
                let name = direction["name"] as! String
                let stations = direction["stations"] as! [[String : Any]]
                directionTupleArray.append((scheduleName: tuple.name,
                                            directionName: name,
                                            stationTimes: stations))
            }
        }
        for station in directionTupleArray {
            let scheduleName = station.scheduleName
            for stationTime in station.stationTimes {
                let stationName = stationTime["name"] as! String
                let weekday = stationTime["weekday"] as! [String]
                stationDetailsArray.append((
                    scheduleName: scheduleName,
                    stationName: stationName,
                    direction: station.directionName,
                    dayofWeekSchedule: "weekday",
                    timesArray: weekday) as! StationsVC.StationDetails)
                //we do we need to cast it?
                //maybe turn this tuple into a struct. I think I'm going to do that.
                if let sunday = stationTime["sunday"] as? [String] {
                    //turn tuple into struct
                }
                if let saturday = stationTime["saturday"] as? [String] {
                 //
                }
                
                if let weekend = stationTime["weekend"] as? [String] {
                    //
                }
                
            }
            
        }
    }
}

extension StationsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
}


