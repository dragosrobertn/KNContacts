//
//  KNContactBookOrdering.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 01/04/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

/**
 Helper struct with helper closures to help with sorting contacts either in a collection of `KNContact` objects or a `KNContactBook`.
 
 - Author: dragosrobertn
 - Version: 1.0.0
 */
public struct KNContactBookOrdering {
    
    /**
     Closure method to sort contact by their birthday during current year in ascending order (earlier first).
     
     - Author: dragosrobertn
     - Returns: A closure method which returns a boolean, to be used in sorting contacts by their birthday during current year.
     - Version: 1.0.0
     */
    static public let thisYearsBirthday = {(_ c1: KNContact, _ c2: KNContact) -> Bool in
        let firstBirthday = c1.birthday(currentYear: true)!
        let secondBirthday = c2.birthday(currentYear: true)!
        return firstBirthday.compare(secondBirthday) == .orderedAscending
    }
    
    /**
     Closure method to sort contact by their full name in ascending order (alphabetical order).
     
     - Author: dragosrobertn
     - Returns: A closure method which returns a boolean, to be used in sorting contacts by their full name.
     - Version: 1.0.0
     */
    static public let fullName = {(_ c1: KNContact, _ c2: KNContact) -> Bool in
        return c1.fullName().compare(c2.fullName()) == .orderedAscending
    }
}
