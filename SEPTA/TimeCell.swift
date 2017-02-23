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
    
    func calculateTimeUntilDepartureTime(departureTime: String)->String{
        var minutes = calculateTimeInMinutesUntilDepartureTime(departureTime: departureTime)
        if minutes < 0 {
            minutes = abs(minutes)
            if minutes == 60 {
                return "1:00"
            } else if minutes < 60 {
                if minutes < 10 {
                    return "0:0\(minutes)"
                } else {
                  return "0:\(minutes)"
                }
            } else if minutes > 60 {
                let min = minutes % 60
                let hr = minutes / 60
                if min < 10 {
                    return "\(hr):0\(min)"
                } else {
                    return "\(hr):\(min)"
                }
            }
        } else {
            return ""
        }
        fatalError()
    }
    
    func configure(departureTime: String){
        countdownTimeLabel.text = ""
        departureTimeLabel.text = departureTime
        countdownTimeLabel.text = calculateTimeUntilDepartureTime(departureTime: departureTime)
    }
    
    
}
