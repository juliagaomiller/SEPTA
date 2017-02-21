//
//  MenuVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/21/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class MenuVC: UITableViewController {
    
    
    //ACTUALLY MIGHT NOT NEED THESE
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let id = segue.identifier {
//            switch(id){
//            case "TimeVC": //make sure we go back to
//                break
//            case "AllSchedulesVC": break
//            case "MySchedulesVC": break //hm might not
//            //        case "SEPTAMapVC":
//            default: break
//                
//            }
//        }
//        
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let i = indexPath.row
        var cell: UITableViewCell!
        switch(i){
        case 0: cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        case 1: cell = tableView.dequeueReusableCell(withIdentifier: "AllSchedulesCell")
        case 2: cell = tableView.dequeueReusableCell(withIdentifier: "MySchedulesCell")
        case 3: cell = tableView.dequeueReusableCell(withIdentifier: "MyStationsCell")
        case 4: cell = tableView.dequeueReusableCell(withIdentifier: "SEPTAMapCell")
        default: fatalError("\(i)")
        }
        return cell
    }
    
}
