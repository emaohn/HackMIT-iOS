//
//  DashboardViewController.swift
//  HackMIT-iOS
//
//  Created by Emmie Ohnuki on 9/14/19.
//  Copyright © 2019 Emmie Ohnuki. All rights reserved.
//

import UIKit
import CoreMotion
import HealthKit
import Charts
import FirebaseDatabase
class DashboardViewController: UIViewController {
    var ref: DatabaseReference!
    var userData = [DataSnapshot]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pointsbutton: UIButton!
    var dataRetrieved = false
    var driving = false;
    var driveTime = 0;
    let timer = Timer()
    var totalPoints = 0;
    var walkingDistance = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        ref = Database.database().reference()
        retrieveData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(openProfile), name: NSNotification.Name("OpenProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMap), name: NSNotification.Name("OpenMap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSettings), name: NSNotification.Name("OpenSettings"), object: nil)
        
        
       
        
        
        let motionActivityManager = CMMotionActivityManager()
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                self.driving = (motion?.automotive)!
                if(self.driving) {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                        self.driveTime += 1
                    })
                } else {
                    self.timer.invalidate()
                }
            }
        }
        
        totalDistance()
  
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
                
                let user = self.userData[0].value as! [String: Any]
                let points = user["points"] as! Int
                self.pointsbutton.titleLabel?.text = "\(points)"
                
                dispatchGroup.leave()
                self.dataRetrieved = true
                self.tableView.reloadData()
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func totalDistance() {
        getDistance { (result) in
            self.walkingDistance = result / 1000
            self.ref?.child("users/InfantDerrickGnanaSusairaj/ecoDist").setValue(self.walkingDistance)
            self.tableView.reloadData()
        }
    }
    func getDistance(completion: @escaping (Double) -> Void) {
        let healthStore = HKHealthStore()
        
        let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsCollectionQuery(quantityType: type,
                                                quantitySamplePredicate: nil,
                                                options: [.cumulativeSum],
                                                anchorDate: startOfDay,
                                                intervalComponents: interval)
        query.initialResultsHandler = { _, result, error in
            var resultCount = 0.0
            result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in
                
                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.meter())
                    
                } // end if
                
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in
            
            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.count())
                // Return
                DispatchQueue.main.async {
                   
                    completion(resultCount)
                }
            } // end if
        }
        healthStore.execute(query)
    }
    
    func authorizeHealthKit() {
        HealthKitSetupAssistant.authorizeHealthKit { (authorized, error) in
            
            guard authorized else {
                
                let baseMessage = "HealthKit Authorization Failed"
                
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                
                return
            }
            
            print("HealthKit Successfully Authorized.")
        }

    }
    
    @IBAction func menuToggled(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @objc func openProfile() {
        performSegue(withIdentifier: "openProfile", sender: nil)
    }
    
    @objc func openMap() {
        performSegue(withIdentifier: "openMap", sender: nil)
    }
    
    @objc func openSettings() {
        performSegue(withIdentifier: "openSettings", sender: nil)
    }
    
    @IBAction func menuButtonTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
    }
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        
    }

}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dataRetrieved) {
            return 5
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dashCell") as! DashboardTableViewCell
        var user = userData[0].value as! [String:Any]
        switch indexPath.row {
        case 0:
            cell.iconImageView.image = UIImage(named: "light.png")
            cell.label.text = "0.56 Ibs of CO2 / kW"
        case 1:
            //user["co2]
            cell.iconImageView.image = UIImage(named: "car.png")
            cell.label.text = "0.56 Ibs of CO2 / mi"
        case 2:
            cell.iconImageView.image = UIImage(named: "walk.png")
            let distance = String(format: "%.2f", walkingDistance)
            cell.label.text = "\(distance) km"
        case 3:
            cell.iconImageView.image = UIImage(named: "heart.png")
            cell.label.text = "3 hours"
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: self.performSegue(withIdentifier: "openEnergyBreakdown", sender: nil)
        case 1: self.performSegue(withIdentifier: "openTravelBreakdown", sender: nil)
        case 3: self.performSegue(withIdentifier: "openVolunteeringBreakdown", sender: nil)
        default: break;
        }
    }
    
}
