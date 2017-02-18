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
    
    var stationTimes = [String]()
    //var current station
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findAndDisplayClosestStation()
        
//        print(stationDetailArray.count)
//        for x in stationDetailArray {
//            print(x.stationName, x.direction, x.dayOfWeekSchedule, x.timesArray)
//            
//        }
    }
    
    func displayCurrentDate(){
        //get current date
    }
    
    @IBAction func openMenu(){
        
    }
    
    @IBAction func switchStations(){
        
    }
    
    @IBAction func switchDayOfWeekSchedule(){
        
    }
    
    func findAndDisplayClosestStation(){
        //get your location and compare with locations of your favorite stations.
        //displayStation func
    }
    
    func displayStation(station: StationDetail){
        lineNameLabel.text = station.stationName
        directionLabel.text = station.direction
        if station.timesArray.count != 0 {
           stationTimes = station.timesArray
            tableView.reloadData()
        } else {
            //haven't filled in the times yet for this station
            //display a note reminding yourself to log these hours.
        }
        
    }
    
    
    
}

extension TimeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCell") as! TimeCell
        cell.configure(departureTime: stationTimes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
