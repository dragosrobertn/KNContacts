//
//  DatesUtils.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 20/12/2018.
//  Copyright © 2019-2020 Dragos-Robert Neagu. All rights reserved.
//
#if canImport(UIKit)
import Foundation

/**
 Helper struct which returns date formatters or formatted strings by using the formet formatter.
 The format can be either a valid date format string or a `KNTimeFormat` enum value.
 
 - Author: dragosrobertn
 - Version: 1.2.3
 */
public struct KNDatesUtils {
    
    /// DateFormatter to be used
    private static let dateFormatter = DateFormatter()
    
    /**
     Helper method to return a DateFormatter object to be used in formatted
     
     - Author: dragosrobertn
     - Parameters:
        - format: KNTimeFormat enum option. Required.
        - locale: The locale to use for formatting when localising content
     
     - Returns: A DateFormatter object using the date format passed.
     - Version: 1.2.3
     */
    static public func formatter(with format: KNFormat, locale: Locale = Locale.current) -> DateFormatter {
        return self.formatter(with: format.rawValue, locale: locale)
    }
    
    /**
     Helper method to return a DateFormatter object to be used in formatted
     
     - Author: dragosrobertn
     - Parameters:
        - format: String representing a valid date format. Required.
        - locale: The locale to use for formatting when localising content
     
     - Returns: A DateFormatter object using the date format passed.
     - Version: 1.2.3
     */
    static public func formatter(with format: String, locale: Locale = Locale.current) -> DateFormatter {
        dateFormatter.locale = locale
        dateFormatter.dateFormat = format
        return dateFormatter
    }
    
    /**
     Helper method that returns a formatted date as a string, accepting a KNTimeFormat value.
     
     - Author: dragosrobertn
     - Parameters:
         - from: Date object. Required.
         - format: KNTimeFormat enum value. Required.
         - locale: The locale to use for formatting when localising content
     
     - Returns: A string representing the formatted date based on the KNTimeFormat and date passed in.
     - Version: 1.2.3
     */
    static public func string(from date: Date, format: KNFormat, locale: Locale = Locale.current) -> String {
        return self.string(from: date, format: format.rawValue, locale: locale)
    }
    
    /**
     Helper method that returns a formatted date as a string, aceppting a custom date format as a string. E.g. "YYYY-MM-DD"
     
     - Author: dragosrobertn
     - Parameters:
         - from: Date object. Required.
         - format: String representing a valid custom date format. Required.
         - locale: The locale to use for formatting when localising content
     
     - Returns: A string representing the formatted date based on the custom date format and date passed in.
     - Version: 1.2.3
     */
    static public func string(from date: Date, format: String, locale: Locale = Locale.current) -> String {
        return self.formatter(with: format, locale: locale).string(from: date)
    }
    
}

#endif
