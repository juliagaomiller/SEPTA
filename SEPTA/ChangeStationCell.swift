//
//  ChangeStationCell.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/18/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class ChangeStationCell: UITableViewCell {
    
    @IBOutlet var stationNameLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    
    func configure(stationName: String, direction: String){
        stationNameLabel.text = stationName
        directionLabel.text = direction
    }
    
}
