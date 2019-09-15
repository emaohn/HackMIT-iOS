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

class DashboardViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    var driving = false;
    var driveTime = 0;
    let timer = Timer()
    var totalPoints = 0;
    var walkingDistance = 0.0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(openProfile), name: NSNotification.Name("OpenProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openMap), name: NSNotification.Name("OpenMap"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSettings), name: NSNotification.Name("OpenSettings"), object: nil)
        
        
        //statusLabel.text = "\(driveTime)"
        
        
        let motionActivityManager = CMMotionActivityManager()
        if CMMotionActivityManager.isActivityAvailable() {
            motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
                self.driving = (motion?.automotive)!
                if(self.driving) {
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
                        self.driveTime += 1
                        self.statusLabel.text = "\(self.driveTime)"
                    })
                } else {
                    self.timer.invalidate()
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
                    resultCount = sum.doubleValue(for: HKUnit.count())
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
                    self.walkingDistance = resultCount
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

//    func getTodaysDistance(completion: @escaping (Double) -> Void) {
//        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
//
//        let now = Date()
//        let startOfDay = Calendar.current.startOfDay(for: now)
//        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
//
//        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
//            guard let result = result, let sum = result.sumQuantity() else {
//                completion(0.0)
//                return
//            }
//            completion(sum.doubleValue(for: HKUnit.count()))
//        }
//
//        healthStore.execute(query)
//    }
    
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
