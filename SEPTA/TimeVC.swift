//
//  TimeVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/16/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class TimeVC: UIViewController {
    
    @IBOutlet var lineNameLabel: UILabel!
    @IBOutlet var directionLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension TimeVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
