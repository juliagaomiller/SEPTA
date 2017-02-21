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
//        self.view.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        loadRailCells()
        tableView.reloadData()
    }
    
    @IBAction func next(){
        //MAKE SURE THAT AT LEAST ONE SCHEDULE HAS BEEN SELECTED
        var index = 0
        favoritedLines.removeAll()
        for cell in scheduleCells {
            if cell.accessoryType == .checkmark {
                let line = lines[index]
                favoritedLines.append(line)
            }
            index += 1
        }
        performSegue(withIdentifier: "StationsVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let vc = segue.destination as! StationsVC
            UserDefaults.standard.set(favoritedLines, forKey: "favoritedLines")
        print(favoritedLines.count)
            vc.selectedLines = favoritedLines
    }
    
}

extension SchedulesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        return lines.count
        return scheduleCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell")!
//        cell.textLabel?.text = lines[indexPath.row]["name"] as! String?
//        return cell
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
    
//    func loadRailLines(){
//        if let path = Bundle.main.path(forResource: "septa", ofType: "json") {
//            if let json = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe){
//                if let data = try? JSONSerialization.jsonObject(with: json)
//                {
//                    if let all = data as? [String:Any] {
//                        lines = all["lines"] as! [[String:Any]]
//
//                    }
//                } else { print("Couldn't convert file from JSON data to Any. Check your JSON file for errors.") }
//            }
//        }
//    }
    
    
}
