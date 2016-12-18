//
//  Play.swift
//  Timely
//
//  Created by admin on 16/12/16.
//  Copyright © 2016 admin. All rights reserved.
//

/**
 *  When to get the location from the user?
 *  Should the location continuosly?
 *  If yes, how frequently
 *  If no, track location as soon as user clicks CREATE-CHECKIN-BUTTON
 *  Now you have the latitude and longitude
 *  There is already an existing list of permitted locations for the user
 *  Check if the obtained lat and lon are in this list(google on searching for locations)
 *  If it is present, perform segue, display the corresponding company name in the view controller
 *  If not present, two scenarios
 *      1. Throw an alert dialogue(Location not permitted) and not move to the next screen
 *      2. If that is not a good method, ask giri what to do.. (You can still go to the next view 
 *         controller and disable user interation for the CHECKIN-BUTTON
 *  Store the location in user defaults.
 *  What if the user clicks CREATE-CHECKIN-BUTTON, goes to the next view controller and comes out of the place?
 *  So, when the user clicks CHECKIN-BUTTON, check for location again, or keep tracking location continuosly in the CHECKIN-VIEW-CONTROLLER. If the user comes out automatically do something about it.
 **/

import UIKit
import Foundation

func play() {

    let date = NSDate()

    let calendar = NSCalendar.current

    let hour = calendar.component(.hour, from: date as Date)
    
    let minutes = calendar.component(.minute, from: date as Date)

    let day = calendar.component(.day, from: date as Date)

    let today = calendar.component(.weekdayOrdinal, from: date as Date)

    print(date)
    print(today)
    print(day)
    print(hour)
    print(minutes)

    //let myLocale = Locale(identifier: "bg_BG")

    //: ### Setting an application-wide `TimeZone`
    //: Notice how we use if-let in case the abbreviation is wrong. It will fallback to the default timezone in that case.
    if let myTimezone = TimeZone(abbreviation: "EEST") {
        print("\(myTimezone.identifier)")
    }


    //: ### Using a `DateFormatter`
    //: You can set a locale and styles to the date formatter. This allows the dates to be formatted in the given language and provides automatic handling of the preferred date formatting in the locale
    let formatter = DateFormatter()

    formatter.dateFormat = "yyyy'-'MM'-'dd"

    let dateStr = formatter.string(from: date as Date)
    print(dateStr)

    let startTime = TimeInterval()
    print(startTime)
    let currentTime = NSDate.timeIntervalSinceReferenceDate
    print(currentTime)
    let elapsedTime: TimeInterval = currentTime - startTime
    print(elapsedTime)
    let timerMinutes = Int(elapsedTime / 60.0)
    print(timerMinutes)
}



