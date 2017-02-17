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
        tableView.delegate = self
        tableView.dataSource = self
        
       // print(tableView.isHidden)
        
        loadRailLines()
        tableView.reloadData()
    }
    
    @IBAction func next(){
        var index = 0
        for cell in scheduleCells {
            if cell.accessoryType == .checkmark {
                let line = lines[index]
                //print(line)
                selectedLines.append(line)
            }
            index += 1
        }
        performSegue(withIdentifier: "StationsVC", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! StationsVC
        vc.selectedLines = selectedLines
        
    }
    
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
                            //print(scheduleCells.count)
                        }

                    }
                } else { print("couldn't convert file") }
            }
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
