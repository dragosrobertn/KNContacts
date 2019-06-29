//
//  DatesUtils.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 20/12/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

/**
 Helper struct which returns date formatters or formatted strings by using the formet formatter.
 The format can be either a valid date format string or a `KNTimeFormat` enum value.
 
 - Author:
 dragosrobertn
 
 - Version:
 1.0.0
 */
public struct KNDatesUtils {
    private let formatter = DateFormatter()
    
    // Initialiser
    public init() {}
    
    /**
     Helper method to return a DateFormatter object to be used in formatted
     
     - Author:
     dragosrobertn
     
     - Returns:
     A DateFormatter object using the date format passed.
     
     - Parameters:
        - format: KNTimeFormat enum option. Required.
     
     - version:
     1.0.0
     */
    public func formatter(with format: KNTimeFormat) -> DateFormatter {
        return self.formatter(with: format.rawValue)
    }
    
    /**
     Helper method to return a DateFormatter object to be used in formatted
     
     - Author:
     dragosrobertn
     
     - Returns:
     A DateFormatter object using the date format passed.
     
     - Parameters:
        - format: String representing a valid date format. Required.
     
     - version:
     1.0.0
     */
    public func formatter(with format: String) -> DateFormatter {
        formatter.dateFormat = format
        return formatter
    }
    
    /**
     Helper method that returns a formatted date as a string, accepting a KNTimeFormat value.
     
     - Author:
     dragosrobertn
     
     - Returns:
     A string representing the formatted date based on the KNTimeFormat and date passed in.
     
     - Parameters:
         - from: Date object. Required.
         - format: KNTimeFormat enum value. Required.
     
     - version:
     1.0.0
     */
    public func string(from date: Date, format: KNTimeFormat) -> String {
        return self.string(from: date, format: format.rawValue)
    }
    
    /**
     Helper method that returns a formatted date as a string, aceppting a custom date format as a string. E.g. "YYYY-MM-DD"
     
     - Author:
     dragosrobertn
     
     - Returns:
     A string representing the formatted date based on the custom date format and date passed in.
     
     - Parameters:
         - from: Date object. Required.
         - format: String representing a valid custom date format. Required.
     
     - version:
     1.0.0
     */
    public func string(from date: Date, format: String) -> String {
        return self.formatter(with: format).string(from: date)
    }
    
}
