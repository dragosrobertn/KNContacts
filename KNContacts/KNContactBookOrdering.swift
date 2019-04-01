//
//  KNContactBookOrdering.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 01/04/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

public struct KNContactBookOrdering {
    
    public init() {}
    
    public let thisYearsBirthday = {(_ c1: KNContact, _ c2: KNContact) -> Bool in
        let firstBirthday = c1.birthday(currentYear: true)!
        let secondBirthday = c2.birthday(currentYear: true)!
        return firstBirthday.compare(secondBirthday) == .orderedAscending
    }
    
    public let fullName = {(_ c1: KNContact, _ c2: KNContact) -> Bool in
        return c1.fullName().compare(c2.fullName()) == .orderedAscending
    }
}
