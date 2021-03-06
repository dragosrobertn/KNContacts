//
//  KNTimeFormat.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 01/04/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//
#if canImport(UIKit)
/// Typealias KNFormat
public typealias KNFormat = KNDateTimeFormat

/// Typealias KNTimeFormat - for backwards compatibility
public typealias KNTimeFormat = KNDateTimeFormat

/**
 Enum helper, returns a String that represents a time format such as "HH:mm", "yyyy-MM-dd".
 
 - Author: dragosrobertn
 - Returns: A string representing a time format.
 - Version: 1.1.0
 */
public enum KNDateTimeFormat: String, Codable {
    /// Date format represented as "HH:mm". E.g. "10:30"
    case hourAndMinutes = "HH:mm"
    
    /// Date format represented as "d MMM". E.g. "1 Jan"
    case dayAndMonth = "d MMM"
    
    /// Date format represented as "yyyy-MM-dd". E.g. "2019-01-01"
    case fullDate = "yyyy-MM-dd"
    
    /// Date format represented as "yyyy-MM-dd HH:mm". E.g. "2019-01-01 10:30"
    case timeStamp = "yyyy-MM-dd HH:mm"
    
    /// Date format represented as "d MMMM". E.g. "1 January"
    case dayAndFullMonth = "d MMMM"
    
    /// Date format represented as "MMMM". E.g. "January"
    case fullMonth = "MMMM"
}

#endif
