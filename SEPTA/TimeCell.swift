//
//  TimeCell.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/14/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class TimeCell: UITableViewCell {
    
    @IBOutlet var departureTimeLabel: UILabel!
    @IBOutlet var countdownTimeLabel: UILabel!
    @IBOutlet var timeToDestinationLabel: UILabel!
    
    
    func configure(departureTime: String){
        departureTimeLabel.text = departureTime
    }
    
    
}
