//
//  AllStationsVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/21/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class AllStationsVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var directionLabel: UILabel!
    
    var scheduleName: String!
    var currentDirection: String!
    var selectedStation = [[String:Any]]()
    var stationDirectionsArray = [SelectStation]()
    
    var straightDirectionStationNames = [String]()
    var reverseDirectionStationNames = [String]()
    var straightDirectionName: String!
    var reverseDirectionName: String!
    
    var reverseDirection = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        createStationNames()
        createStationDirectionArray()
    }
    
    @IBAction func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchDirections(){
        if reverseDirection {
            directionLabel.text = reverseDirectionName
        } else {
            directionLabel.text = straightDirectionName
        }
        tableView.reloadData()
    }
    
    func createStationNames(){
        print(selectedStation)
        var i = 0
        for x in selectedStation {
            let stations = x["stations"] as! [[String:Any]]
            for s in stations {
                let name = s["name"] as! String
                if i == 0 {
                    straightDirectionName = x["name"] as! String!
                    straightDirectionStationNames.append(name)
                } else if i == 1 {
                    reverseDirectionName = x["name"] as! String!
                    reverseDirectionStationNames.append(name)
                } else { fatalError("there should only be a straight and reverse direction in selectedStation: count =  \(selectedStation.count)")
                }
                i += 1
            }
        }
    }
    
    func createStationDirectionArray(){
        stationDirectionsArray.removeAll()
        for x in selectedStation {
            stationDirectionsArray.append((line: scheduleName,
                                           direction: x["name"] as! String,
                                           stationNamesArray: x["stations"] as! [[String : Any]]))

        }
    }
    
    func createStationDetail(dict: [[String:Any]]){
//        let lineName = scheduleName
//        for x in dict {
//            let direction = x["name"]
//            let stat
//        }
        //    var scheduleName: String //e.g. Chestnut Hill West
        //    var stationName: String //e.g. Allen Lane
        //    var direction: String //e.g. -> Center City
        //    var dayOfWeekSchedule: String //e.g. weekday
        //    var timesArray: [String] // e.g. 5:55 AM, 7:30 AM...
    }
    
    
}

extension AllStationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reverseDirection {
            return reverseDirectionStationNames.count
        } else {
            return straightDirectionStationNames.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if reverseDirection {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllStationsCell") as! AllStationsCell
            cell.configure(stationName: reverseDirectionStationNames[indexPath.row], favorited: false)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AllStationsCell") as! AllStationsCell
            cell.configure(stationName: straightDirectionStationNames[indexPath.row], favorited: false)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //NEXT: SEGUE PROPERLY FROM ALLSTATIONVC to TIMEVC
        if reverseDirection {
            //stationdirectionsarray[1]
        } else {
            //stationdirecitonsarray[2]
        }
        //i need to create 2-3 station details to be segued into timeVC.
        //I chose a specific station, --> need to go to this stations specific
        //I 
        print(selectedStation)
        createStationDetail(dict: selectedStation)


    }
    
}
