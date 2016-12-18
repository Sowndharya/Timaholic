//
//  CheckinViewController.swift
//  Timely
//
//  Created by admin on 16/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation

class CheckinViewController : UIViewController, LocationUpdateProtocol {
    
    var checkinTime = NSDate()
    var checkoutTime = NSDate()
    
    var startTime = TimeInterval()
    
    var timer: Timer = Timer()
    let LocationMgr = UserLocationManager()
    
    let formatter = DateFormatter()
    let calendar = NSCalendar.current
    
    var newCheckin = [NSManagedObject]()
    
    var userId = "user1"
    
    var workingHours : Int = 0
    var workingMins : Int = 0
    var elapsedTime : TimeInterval = 0.0
    
    var locLat : Double = 0.0
    var locLon : Double = 0.0
    
    let checkinPrefs = UserDefaults.standard
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var checkinButton: UIButton!
    
    @IBAction func checkinClicked(_ sender: UIButton) {
        
        if (checkinPrefs.object(forKey: "isCheckedIn")) != nil {
            
            checkoutTime = NSDate()
            sender.setTitle("Checkin", for: UIControlState.normal)
            checkinPrefs.removeObject(forKey: "isCheckedIn")
            print(workingHours)
            print(workingMins)
            stopUpdatingTimer()
            checkoutTime = NSDate()
            self.createCheckin(checkinHours: workingHours, checkinMins: workingMins)
            
        } else {
            
            
            checkinTime = NSDate()
            checkinButton.setTitle("Checkout", for: UIControlState.normal)
            
            startTime = NSDate.timeIntervalSinceReferenceDate
            
            checkinPrefs.set(true, forKey: "isCheckedIn")
            checkinPrefs.set(startTime as Double, forKey: "checkinTime")
            
            startUpdatingTimer()
            
        }
    }
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        let checkinTime = checkinPrefs.object(forKey: "checkinTime") as! TimeInterval
        
        //Find the difference between current time and start time.
        elapsedTime = currentTime - checkinTime
        
        
        // There are two ways to print the timer...
        // Either use the DateComponentsFormatter with the unitsStyle Property
        // Or calcuate hours, minutes, seconds seperately
        // Anyway I have to calculate hours and minutes in order to compute the PAYABLE-AMOUNT
        
        // Method 1
        
        let formatter1 = DateComponentsFormatter()
        formatter1.unitsStyle = .abbreviated
        let time = formatter1.string(from: elapsedTime)
        print(time!)
        
        // Method 2
        
        workingHours = Int(elapsedTime) / 3600
        workingMins = (Int(elapsedTime) / 60) % 60
        
        let hours = UInt8(elapsedTime / 3600.0)
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        let seconds = UInt8(elapsedTime)
        
        
        print("hoursnor: \(workingHours)")
        print("minutesnor: \(workingMins)")
        print("hours: \(hours)")
        print("minutes: \(minutes)")
        print("second: \(seconds)")
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strHours = String(format: "%02d", hours)
        print("\(strHours):\(strMinutes):\(strSeconds)")
        
        
        timerLabel.text = time!
    }
  
    func createCheckin(checkinHours: Int, checkinMins: Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "UserCheckin", in: managedContext)!
        
        let checkin = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let checkinId = "12345"
        
        checkin.setValue(userId, forKeyPath: "userId")
        checkin.setValue("1235", forKeyPath: "locationId")
        checkin.setValue(checkinId, forKeyPath: "checkinId")
        
        checkin.setValue(checkinHours, forKeyPath: "checkinHours")
        checkin.setValue(checkinMins, forKeyPath: "checkinMins")
        
        checkin.setValue(checkinTime, forKeyPath: "checkinTime")
        checkin.setValue(checkoutTime, forKey: "checkoutTime")
        
        checkin.setValue(21*3, forKey: "payableAmount")
        
        do {
            try managedContext.save()
            print("Checkin Created")
            
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func locationDidUpdateToLocation(location: CLLocationCoordinate2D) {
        
        locLat = location.latitude as Double
        locLon = location.longitude as Double
        if checkPermittedLocation() {
        } else {
            Utilities.showAlertActionDefault(self, "Location error", "Not a permitted Location")
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timerLabel.adjustsFontSizeToFitWidth = true
        //if (checkinPrefs.object(forKey: "isCheckedIn")) == nil {
          //  LocationMgr.delegate = self
            //LocationMgr.getLocation()
        //}
        
        startUpdatingTimer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CheckinViewController.stopUpdatingTimer), name:NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CheckinViewController.startUpdatingTimer), name:NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
    }
    
    
    func startUpdatingTimer() {
        if (checkinPrefs.object(forKey: "isCheckedIn")) != nil {
            checkinButton.setTitle("Checkout", for: UIControlState.normal)
            if (!timer.isValid) {
                let aSelector : Selector = #selector(CheckinViewController.updateTime)
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            }
        }
        
    }
    
    func stopUpdatingTimer() {
        
        timer.invalidate()
    }
    
    func checkPermittedLocation() -> Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(true)
        stopUpdatingTimer()
    }
    

}
