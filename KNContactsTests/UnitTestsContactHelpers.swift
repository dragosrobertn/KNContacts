//
//  UnitTestsContactHelpers.swift
//  KINNUnitTests
//
//  Created by Dragos-Robert Neagu on 30/11/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import XCTest

class UnitTestsContactHelpers: XCTestCase {

    class func getMutableContact() -> CNMutableContact {
        let contact = CNMutableContact()
        let dateComponents = DateComponents(calendar: Calendar.current, year: 1990, month: 01, day: 01)

        contact.familyName = "Smith"
        contact.givenName = "John"
        contact.birthday = dateComponents
        contact.emailAddresses =
            [CNLabeledValue(label: "work", value: "first"),
             CNLabeledValue(label: "home", value: "second")]
        contact.phoneNumbers = [
            CNLabeledValue(label: "work", value: CNPhoneNumber(stringValue: "123456789")),
            CNLabeledValue(label: "home", value: CNPhoneNumber(stringValue: "987654321"))]
        
        return contact
    }
    
    class func getKNContactWithMutableContact() -> KNContact {
        let mutableContact = self.getMutableContact()
        return KNContact(for: mutableContact)
    }
}
