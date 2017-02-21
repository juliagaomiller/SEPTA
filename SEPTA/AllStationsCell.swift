//
//  AllStationsCell.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/21/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class AllStationsCell: UITableViewCell {
    
    @IBOutlet var heartButton: UIButton!
    @IBOutlet var stationLabel: UILabel!
    
//    var station: SelectStation!
//    var index: Int!
    
    
    func configure(stationName: String, favorited: Bool){
        stationLabel.text = stationName
        if favorited {
            heartButton.setImage(#imageLiteral(resourceName: "redHeart"), for: .normal)
        } else {
            heartButton.setImage(#imageLiteral(resourceName: "greyHeart"), for: .normal)
        }
//        self.station = selectStation
//        self.index = index
    }
    
}
