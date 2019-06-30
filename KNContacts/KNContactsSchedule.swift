//
//  KNContactSchedule.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 16/02/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

/**
 A collection of contact identifier strings grouped by a time format to create contact schedules.
 Can be used for persisting the IDs to a store or to User Defaults.
 
 - Author: dragosrobertn
 - Version: 1.0.0
 */
public struct KNContactsSchedule {
    
    /// The name of the schedule
    public let name: String
    
    /// The time format to save the schedule in
    public let format: KNDateTimeFormat
    
    /// The collection of sorted contact identifier, grouped based on a time format.
    private var schedule: [String: [String]] = [:]
    
    /**
     Initialises a `KNContactSchedule` with a name and time format.
     
     - Author:dragosrobertn
     
     - Parameters:
        - name: The name of the contact schedule.
        - format: The `KNTimeFormat` value to be used for grouping the contact identifiers by and later be retrieved. Optional. Defaults to `KNTimeFormat.fullDate`
     
     - Version: 1.0.0
    */
    public init(name: String, format: KNDateTimeFormat = .fullDate) {
        self.name = name
        self.format = format
    }
    
    /**
    Adds multiple contact identifers to the schedule for a particular day passed as Date type.
     
     - Author: dragosrobertn
     
     - Parameters:
         - list: An array of strings representing contact identifiers. Required.
         - to: The Date value to be used for grouping the contact identifiers by and later be retrieved.
     
     - Version: 1.0.0
    */
    public mutating func add(list: [String], to day: Date) {
        let date = KNDatesUtils.string(from: day, format: format)
        self.schedule[date] = list
    }
    
    /**
     Adds multiple contact identifers to the schedule for a particular day passed as a String type.
     The string representing a datetime format will be parsed and if invalid, the method will return without adding the identifiers to the schedule.
     
     - Author:dragosrobertn
     
     - Parameters:
         - list: An array of strings representing contact identifiers. Required.
         - fromString: A string value representing a valid date format to be used for grouping the contact identifiers by and later be retrieved.
     
     - Version: 1.1.0
     */
    public mutating func add(list: [String], to day: String) {
        guard let date = KNDatesUtils.formatter(with: self.format).date(from: day) else {
            return
        }
        let conformedDate = KNDatesUtils.string(from: date, format: self.format)
        self.schedule[conformedDate] = list
    }
    
    /**
     Retrieves the whole schedule.
     
     - Author: dragosrobertn
     - Returns: A dictionary of date strings, each holding the schedule of contacts as an array of contact identifers for that date.
     - Version: 1.0.0
     */
    public func getSchedule() -> [String: [String]] {
        return self.schedule
    }
    
    /**
     Retrieves the schedule for a particular day
     
     - Author: dragosrobertn
     - Parameters:
        - day: A Date representing the day for which day to retrieve the schedule for.
     
     - Returns: The schedule of contacts as an array of contact identifiers strings for the specified date.
     - Version: 1.0.0
     */
    public func getSchedule(for day: Date) -> [String] {
        let date = KNDatesUtils.string(from: day, format: format)
        guard let daySchedule = self.schedule[date] else { return [] }
        return daySchedule
    }
    
    /**
     Retrieves the schedule for the current day.
     
     - Author: dragosrobertn
     - Returns: The schedule of contacts as an array of contact identifiers strings for the current date.
     - Version: 1.0.0
    */
    public func scheduleForToday() -> [String] {
        return self.getSchedule(for: Date())
    }
    
    /**
    Resets the schedule by invalidating the stored schedule collection.
     
     - Author: dragosrobertn
     - Version: 1.0.0
    */
    public mutating func reset() {
        self.schedule.removeAll()
    }
}

extension KNContactsSchedule {
    /**
     Adds multiple contact identifers to the schedule for a particular day passed as a String type.
     The string representing a datetime format will be parsed and if invalid, the method will return without adding the identifiers to the schedule.
     
     - Author: dragosrobertn
     
     - Parameters:
         - list: An array of strings representing contact identifiers. Required.
         - fromString: A string value representing a valid date format to be used for grouping the contact identifiers by and later be retrieved.
     
     - Version: 1.0.0
     - Warning: Deprecated. Use 'add(list:to:)' instead.
     */
    @available(*, deprecated, message: "Use 'add(list:to:)' instead.")
    public mutating func add(list: [String], fromString day: String) {
       self.add(list: list, to: day)
    }
}
