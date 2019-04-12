//
//  KNContact.swift
//  KINN
//
//  Created by Dragos-Robert Neagu on 25/01/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import UIKit

public struct KNContact: Hashable {
    
    public let details: CNContact
    public var id: String { return self.details.identifier }
    
    public init(for contact: CNContact) {
        self.details = contact
    }

    /**
    Returns the full name of contacts using a formatting style (fullName or phoneticFullName).

    - Author:
    dragosrobertn

    - returns:
    A string representing the full name. It can be an empty string.

    - parameters:
        - format: A CNContactFormatterStyle enum option. Optional. Defaults to .fullName

    - version:
    1.0.0
    */
    public func fullName(format: CNContactFormatterStyle = .fullName) -> String {
        guard let name = CNContactFormatter.string(from: self.details, style: format) else { return "" }
        return name
    }
    
    public func birthday(currentYear: Bool = false) -> Date? {
        if (self.details.birthday?.day == nil || self.details.birthday?.month == nil) {
            return nil
        }
        
        var components = DateComponents(month: self.details.birthday?.month, day: self.details.birthday?.day)
        
        if self.details.birthday?.year != nil {
            components.year = self.details.birthday?.year
        }
        
        if (currentYear) {
            let year = Calendar.current.component(.year, from: Date())
            components.year = year
        }
        
        return Calendar.current.date(from: components)!
    }
    
    public func formattedBirthday(with format: KNTimeFormat = .dayAndMonth,
                           currentYear : Bool = false) -> String {
        return self.formattedBirthday(with: format.rawValue, currentYear: currentYear)
    }
    
    public func formattedBirthday(with format: String,
                           currentYear : Bool = false) -> String {
        guard let date = self.birthday(currentYear: currentYear) else { return String() }
        return KNDatesUtils().string(from: date, format: format)
    }
    
    public func getFirstPhoneNumber() -> String {
        let phoneNumbers = self.details.phoneNumbers
        return phoneNumbers.first?.value.stringValue ?? String()
    }
    
    public func getFirstEmailAddress() -> String {
        let emailAddresses = self.details.emailAddresses
        return String(emailAddresses.first?.value ?? "")
    }
    
    public func isBirthdayToday() -> Bool {
        let todayFormattedString = KNDatesUtils().string(from: Date(), format: .dayAndMonth)
        return self.formattedBirthday() == todayFormattedString
    }
    
    public func isBirthdayComing(in days: Int) -> Bool {
        let futureDate = Calendar.current.date(byAdding: .day, value: days, to: Date())!
        guard let birthday = self.birthday(currentYear: true) else {
            return false
        }
        
        return birthday.isBetween(Date(), and: futureDate) ? true : false
    }
    
    public func getAge() -> Int? {
        guard self.details.birthday?.year != nil else { return nil }
        
        let components = Calendar.current.dateComponents([.year], from: birthday()!, to: Date())
        return components.year!
    }
    
    public func getAgeAsOrdinalAtNextBirthday() -> String! {
        guard self.getAge() != nil else { return String() }
        let ageAtNextBirthday = self.getAge()! + 1
        return ageAtNextBirthday.ordinal
    }
    
    public func getAgeAtNextBirthday() -> String? {
        guard let age = self.getAge() else { return nil }
        return String(format: "%d", age.advanced(by: 1))
    }
    
    public func getAgeAsOrdinal() -> String? {
       guard let age = self.getAge() else { return nil }
       return age.ordinal
    }
}

extension KNContact: Comparable {
    public static func < (lhs: KNContact, rhs: KNContact) -> Bool {
        return lhs.id < rhs.id
    }
}

extension KNContact: Equatable {
    public static func == (lhs: KNContact, rhs: KNContact) -> Bool {
        return lhs.id == rhs.id
    }
}
