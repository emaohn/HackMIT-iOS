//
//  SideMenuViewController.swift
//  HackMIT-iOS
//
//  Created by Emmie Ohnuki on 9/14/19.
//  Copyright © 2019 Emmie Ohnuki. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        switch indexPath.row {
        case 0:
            NotificationCenter.default.post(name: NSNotification.Name("OpenProfile"), object: nil)
        case 1: break
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name("OpenMap"), object: nil)
        case 3:
            NotificationCenter.default.post(name: NSNotification.Name("OpenSettings"), object: nil)
        default: break
        }
    }
}
