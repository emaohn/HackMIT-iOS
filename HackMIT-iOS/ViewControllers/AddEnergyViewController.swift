//
//  AddEnergyViewController.swift
//  HackMIT-iOS
//
//  Created by Emmie Ohnuki on 9/15/19.
//  Copyright © 2019 Emmie Ohnuki. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AddEnergyViewController: UIViewController {
    var ref: DatabaseReference!
    var userData = [DataSnapshot]()
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        retrieveData()
        setup()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        segmentedControl.selectedSegmentIndex = 0
        timeLabel.text = "hours"
        amountLabel.text = "kilowatts"
    }
    
    func retrieveData() {
        let dataRef = Database.database().reference().child("users")
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        DispatchQueue.main.async {
            dataRef.observeSingleEvent(of: .value) { (snapshot) in
                
                guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {return }
                
                //self.user = [DataSnapshot]()
                
                for user in snapshot {
                    self.userData.append(user)
                }
                
                dispatchGroup.leave()
                
            }
        }
        
    }
    
    @IBAction func segmentedControlToggled(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            timeLabel.text = "days"
            amountLabel.text = "kilowatts"
        case 1:
            timeLabel.text = "days"
            amountLabel.text = "gallons"
        case 2:
            timeLabel.text = "days"
            amountLabel.text = "gallons"
        default: break
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleAddEnergy"), object: nil)
        let user = userData[0].value as! [String: Any]
        let val = user["co2e"] as! Double
    ref?.child("users/InfantDerrickGnanaSusairaj/co2e").setValue(val + 50)

    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleAddEnery"), object: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}