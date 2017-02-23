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
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        loadRailCells()
        showOkayAlertView(message: "Welcome to the digital version of the SEPTA Regional Rail Schedules. Please select at least one schedule.")
        tableView.reloadData()
    }
    
    @IBAction func next(){
        var index = 0
        favoritedLines.removeAll()
        for cell in scheduleCells {
            if cell.accessoryType == .checkmark {
                let line = lines[index]
                favoritedLines.append(line)
            }
            index += 1
        }
        if favoritedLines.count == 0 {
            showOkayAlertView(message: "Please select at least one schedule")
        } else {
            performSegue(withIdentifier: "StationsVC", sender: nil)
        }
    }
    
    func showOkayAlertView(message: String){
        //NEXT
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let vc = segue.destination as! StationsVC
            UserDefaults.standard.set(favoritedLines, forKey: "favoritedLines")
            vc.selectedLines = favoritedLines
    }
    
}

extension SchedulesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func loadRailCells(){
        for line in lines {
            let name = line["name"] as! String
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleCell
            cell.scheduleLabel.text = name
            scheduleCells.append(cell)
        }

    }
    
    
}
