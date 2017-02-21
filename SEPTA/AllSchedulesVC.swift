//
//  AllSchedulesVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/21/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class AllSchedulesVC: UIViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var allSchedules = [[String:Any]]()
    var favoriteSchedules = [[String:Any]]()
    var selectedScheduleName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        allSchedules = lines
//        print(lines)
        favoriteSchedules = favoritedLines
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = revealViewControllerWidth
//        print(allSchedules)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AllStationsVC" {
            let vc = segue.destination as! AllStationsVC
            vc.selectedStation = sender as! [[String:Any]]
            vc.scheduleName = selectedScheduleName
        }
    }
    
}

extension AllSchedulesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allSchedules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllScheduleCell") as! AllScheduleCell
        cell.configure(scheduleName: allSchedules[indexPath.row]["name"] as! String)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schedule = allSchedules[indexPath.row]["directions"] as! [[String:Any]]
        selectedScheduleName = allSchedules[indexPath.row]["name"] as! String
//        print(schedule)
            //as! [[String:Any]]
        performSegue(withIdentifier: "AllStationsVC", sender: schedule)
    }
    
}
