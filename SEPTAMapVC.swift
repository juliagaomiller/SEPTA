//
//  SEPTAMapVC.swift
//  SEPTA
//
//  Created by Julia Gao Miller on 2/21/17.
//  Copyright © 2017 Julia Miller. All rights reserved.
//

import UIKit

class SEPTAMapVC: UIViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        self.revealViewController().rearViewRevealWidth = revealViewControllerWidth
    }
    
}
