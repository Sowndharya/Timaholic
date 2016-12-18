//
//  HomeViewController.swift
//  Timely
//
//  Created by admin on 15/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let userId = "09123FR"
    
    @IBOutlet weak var checkinTable: UITableView!
    
    var checkinsForTheDay = [NSManagedObject]()
    let cellReuseIdentifier = "CheckinCell"
    
    let date = NSDate()
    
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkinTable.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        checkinTable.delegate = self
        checkinTable.dataSource = self
        
        let formatter = DateFormatter()
        
        formatter.dateStyle = .medium
        
        let dateStr = formatter.string(from: date as Date)
        
        self.title = dateStr
        
        self.refreshControl.addTarget(self, action: #selector(HomeViewController.loadCheckins), for: UIControlEvents.valueChanged)
        self.checkinTable.addSubview(refreshControl)
        self.loadCheckins()

    }
    
    
    
    func loadCheckins() {
        
        
        let fetchRequest: NSFetchRequest<UserCheckin> = UserCheckin.fetchRequest()
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date as Date)
        components.hour = 00
        components.minute = 00
        components.second = 00
        let startDate = calendar.date(from: components)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = calendar.date(from: components)
        
        fetchRequest.predicate =  NSPredicate(format: "checkinTime >= %@ AND checkinTime =< %@", argumentArray: [startDate!, endDate!])

    
        do {
            
            let searchResults = try getContext().fetch(fetchRequest)
            
            self.checkinsForTheDay.removeAll(keepingCapacity: false)
            print ("num of results = \(searchResults.count)")
            
            for trans in searchResults as [NSManagedObject] {
                self.checkinsForTheDay.append(trans)
            }
            self.refreshControl.endRefreshing()
            self.checkinTable.reloadData()
            
        } catch {
            print("Error with request: \(error)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.checkinsForTheDay.count
    }
    
    @IBAction func createCheckinClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "createCheckin", sender: self)
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        //let cell : CheckinCell = self.checkinTable.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CheckinCell
        
        let cell = self.checkinTable.dequeueReusableCell(withIdentifier: "checkinCell") as! CheckinCell
        cell.bindData(checkins: self.checkinsForTheDay[indexPath.row])
        return cell
        
    }
    
    @IBAction func nextClick(_ sender: UIBarButtonItem) {
    }
    
    
    
    @IBAction func previousClick(_ sender: UIBarButtonItem) {
    }
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
