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
    
    func calculateTimeUntilDepartureTime(hhmm: String)->String{
        var minutes = calculateTimeInMinutesUntilDepartureTime(hhmm: hhmm)
        if minutes < 0 {
            minutes = abs(minutes)
            if minutes == 60 {
                return "1:00"
            } else if minutes < 60 {
                return "0:\(minutes)"
            } else if minutes > 60 {
                let min = minutes % 60
                let hr = minutes / 60
                return "\(hr):\(min)"
            }
        } else {
            return ""
        }
        fatalError()
    }
    
    func configure(departureTime: String){
        departureTimeLabel.text = departureTime
        countdownTimeLabel.text = calculateTimeUntilDepartureTime(hhmm: departureTime)
    }
    
    
}
