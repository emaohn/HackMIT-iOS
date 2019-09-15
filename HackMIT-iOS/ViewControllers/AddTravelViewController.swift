//
//  AddTravelViewController.swift
//  HackMIT-iOS
//
//  Created by Emmie Ohnuki on 9/15/19.
//  Copyright © 2019 Emmie Ohnuki. All rights reserved.
//

import UIKit
import FirebaseDatabase
class AddTravelViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var mpgTextField: UITextField!
    var userData = [DataSnapshot]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        retrieveData()

        // Do any additional setup after loading the view.
        hideKeyboardWhenTappedAround()
        let hideKeyboard = UITapGestureRecognizer(target: self, action: #selector(self.navigationBarTap))
        hideKeyboard.numberOfTapsRequired = 1
        navigationController?.navigationBar.addGestureRecognizer(hideKeyboard)
        // Do any additional setup after loading the view.
    }
  
    @objc func navigationBarTap(_ recognizer: UIGestureRecognizer) {
        view.endEditing(true)
        // OR  USE  yourSearchBarName.endEditing(true)
        
    }
    
    func setup() {
        segmentedControl.selectedSegmentIndex = 0
        distanceTextField.text = ""
        mpgTextField.text = ""
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
            mpgTextField.layer.isHidden = false
           mpgTextField.placeholder = "Miles per gallon"
        case 1:
            mpgTextField.layer.isHidden = true
        case 2:
            mpgTextField.layer.isHidden = true
        default: break
        }
        setup()
    }
    @IBAction func doneButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("AddTravelToggled"), object: nil)
        let user = userData[0].value as! [String: Any]
        let co2e = user["co2e"] as! Double
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            if let distance = Double(distanceTextField.text!), let mpg = Double(mpgTextField.text!) {
            ref?.child("users/InfantDerrickGnanaSusairaj/co2e").setValue(co2e + distance / mpg)
            }
        case 1:
            if let distance = Double(distanceTextField.text!) {
                ref?.child("users/InfantDerrickGnanaSusairaj/co2e").setValue(co2e + distance * 10.15)
            }
        case 2:
            if let distance = Double(distanceTextField.text!) {
                ref?.child("users/InfantDerrickGnanaSusairaj/co2e").setValue(co2e + distance * 0.059)
            }
        case 3:
             if let distance = Double(distanceTextField.text!) {
                ref.child("users/InfantDerrickGnanaSusairaj/co2e").setValue(co2e + distance * 0.277)
            }
        default: break;
        }
        setup()
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("AddTravelToggled"), object: nil)
    }
    
}
extension AddTravelViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddTravelViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
