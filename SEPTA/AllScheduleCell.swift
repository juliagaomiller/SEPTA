//
//  AllScheduleCell.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/21/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class AllScheduleCell: UITableViewCell {
    
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var scheduleLabel: UILabel!
    
    func configure(scheduleName: String){
        scheduleLabel.text = scheduleName
    }
    
}
