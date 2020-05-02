//
//  UnitTestsContactHelpers.swift
//  KINNUnitTests
//
//  Created by Dragos-Robert Neagu on 30/11/2018.
//  Copyright © 2019-2020 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import KNContacts
import XCTest

class UnitTestsContactHelpers: XCTestCase {

    class func getMutableContact() -> CNMutableContact {
        let contact = CNMutableContact()
        let dateComponents = DateComponents(calendar: Calendar.current, year: 1990, month: 01, day: 01)

        contact.familyName = "Smith"
        contact.givenName = "John"
        contact.phoneticGivenName = "Jon"
        contact.birthday = dateComponents
        contact.emailAddresses =
            [CNLabeledValue(label: "work", value: "first"),
             CNLabeledValue(label: "home", value: "second")]
        contact.phoneNumbers = [
            CNLabeledValue(label: "work", value: CNPhoneNumber(stringValue: "123456789")),
            CNLabeledValue(label: "home", value: CNPhoneNumber(stringValue: "987654321"))]
        
        return contact
    }
    
    class func getKNContact() -> KNContact {
        let mutableContact = self.getMutableContact()
        return KNContact(for: mutableContact)
    }
    
    class func getLocalisedStringFor(_ key: String, locale: Locale) -> String {
        var dictionary : [String : [String: String]] = [:]
        
        let spanish = [
            "30th": "30.º",
            "29th": "29.º",
            "1 Jan": "1 ene",
            "1 January": "1 enero",
            "January": "enero"
        ]
        let german = [
            "30th": "30.",
            "29th": "29.",
            "1 Jan": "1 Jan.",
            "1 January": "1 Januar",
            "January": "Januar"
        ]
        let romanian = [
            "30th": "30a",
            "29th": "29a",
            "1 Jan": "1 ian.",
            "1 January": "1 ianuarie",
            "January": "ianuarie"
        ]
        let russian = [
            "30th": "30.",
            "29th": "29.",
            "1 Jan": "1 янв.",
            "1 January": "1 января",
            "January": "января"
        ]
        
        dictionary["es_ES"] = spanish
        dictionary["de_DE"] = german
        dictionary["ro_RO"] = romanian
        dictionary["ru_RU"] = russian
        
        let language = dictionary[locale.identifier]
        return language?[key] ?? key
        
    }
}


extension Array where Element: Comparable {
    func containsSame(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension Array where Element: Hashable {
    func random() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
