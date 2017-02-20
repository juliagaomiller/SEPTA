//
//  SchedulesVC.swift
//  SEPTA
//
//  Created by Julia Miller on 2/6/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import Foundation
import UIKit

class SchedulesVC: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var scheduleCells = [ScheduleCell]()
    var lines = [[String:Any]]()
    var selectedLines = [[String:Any]]()
    
    override func viewDidLoad() {
        self.view.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
//        checkForUserDefaults()
        loadRailLines()
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkForUserDefaults()
    }
    
    @IBAction func next(){
        //MAKE SURE THAT AT LEAST ONE SCHEDULE HAS BEEN SELECTED
        var index = 0
        for cell in scheduleCells {
            if cell.accessoryType == .checkmark {
                let line = lines[index]
                selectedLines.append(line)
            }
            index += 1
        }
        performSegue(withIdentifier: "StationsVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender != nil {
            if segue.identifier == "StationsVC" {
                let vc = segue.destination as! StationsVC
                vc.selectedLines = sender as! [[String:Any]]
            } else if segue.identifier == "TimeVC" {
                let vc = segue.destination as! TimeVC
                vc.savedStationsDict = sender as! [[String:Any]]
                //vc.stationDetailArray = sender as! [[String:Any]]
            }
        } else {
            let vc = segue.destination as! StationsVC
            UserDefaults.standard.set(selectedLines, forKey: "selectedLines")
            vc.selectedLines = selectedLines
        }
        
        
    }
    
}

extension SchedulesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(scheduleCells.count)
        return scheduleCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return scheduleCells[indexPath.row]
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

extension SchedulesVC {
    
    func loadRailLines(){
        if let path = Bundle.main.path(forResource: "septa", ofType: "json") {
            if let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe){
                if let data = try? JSONSerialization.jsonObject(with: json)
                {
                    if let all = data as? [String:Any] {
                        lines = all["lines"] as! [[String:Any]]
                        for line in lines {
                            let name = line["name"] as! String
                            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
                            cell.scheduleLabel.text = name
                            scheduleCells.append(cell)
                        }
                        
                    }
                } else { print("Couldn't convert file from JSON data to Any. Check your JSON file for errors.") }
            }
        }
    }
    
    func checkForUserDefaults(){
        if let stationsExist = UserDefaults.standard.object(forKey: "stationDetailArray") as? [[String:Any]] {
            performSegue(withIdentifier: "TimeVC", sender: stationsExist)
        } else if let linesExist = UserDefaults.standard.object(forKey: "selectedLines") as? [[String:Any]] {
            performSegue(withIdentifier: "StationsVC", sender: linesExist)
        } else {
            self.view.isHidden = false
        }
    }
    
}
