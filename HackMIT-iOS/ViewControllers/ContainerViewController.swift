//
//  ContainerViewController.swift
//  HackMIT-iOS
//
//  Created by Emmie Ohnuki on 9/14/19.
//  Copyright © 2019 Emmie Ohnuki. All rights reserved.
//

import UIKit
import CoreMotion

class ContainerViewController: UIViewController {
    var menuOpen = false
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        leadingConstraint.constant = -275
        menuOpen = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name("ToggleSideMenu"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func toggleSideMenu() {
        if(menuOpen == false) {
            leadingConstraint.constant = 0
            menuOpen = true
        } else {
            menuOpen = false
            leadingConstraint.constant = -275
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
