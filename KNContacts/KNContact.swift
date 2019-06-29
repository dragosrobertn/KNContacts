//
//  KNContact.swift
//  KINN
//
//  Created by Dragos-Robert Neagu on 25/01/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import UIKit

/// KNContact class is a wrapper class which gives quick access to helper methods for a CNContact, like their full name,
/// birthday and age information, first email address or phone number.
public struct KNContact {
    
    // A CNContact object representing the contact.
    public let details: CNContact
    
    // Quick access to the contacts identifier.
    public var id: String { return self.details.identifier }
    
    /**
     Initialises a KNContact object by wrapping a CNContact.
     
     - Author:
     dragosrobertn
     
     - parameters:
     - contact: A CNContact.
     
     - version:
     1.0.0
     */
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
    
    /**
     Returns the birthday of the contact as an optional date, if the contact has birthday information is available.
     
     - Author:
     dragosrobertn
     
     - returns:
     A date representing the contact's birthday or nil.
     
     - parameters:
     - currentYear: A boolean value representing if the birthday date should be returned for the current year. Optional. Defaults to false.
     
     - version:
     1.0.0
     */
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
    
    /**
     Helper method to return a formatted birthday using a KNTimeFormat.
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns a string representing a formatted birthday using the KNTimeFormat passed. If the contact doesn't contain birthday information returns an empty string.
     
     - parameters:
     - format: A KNTimeFormat enum option. Optional. Defaults to .dayAndMonth
     - currentYear: A boolean value representing if the birthday date should be returned for the current year. Optional. Defaults to false.
     
     
     - version:
     1.0.0
     */
    public func formattedBirthday(with format: KNTimeFormat = .dayAndMonth,
                           currentYear : Bool = false) -> String {
        return self.formattedBirthday(with: format.rawValue, currentYear: currentYear)
    }
    
    /**
     Helper method to return a formatted birthday using a string representing a date formatt.
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns a string representing a formatted birthday using the format string passed. If the format is invalid or the contact doesn't contain birthday information returns an empty string.
     
     - parameters:
     - format: A string representing the date format desired to display the birthday. Required.
     - currentYear: A boolean value representing if the birthday date should be returned for the current year. Optional. Defaults to false.
     
     
     - version:
     1.0.0
     */
    public func formattedBirthday(with format: String,
                           currentYear : Bool = false) -> String {
        guard let date = self.birthday(currentYear: currentYear) else { return String() }
        return KNDatesUtils().string(from: date, format: format)
    }
    
    /**
     Helper method to get the first phone number available for the contact as string.
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns a string representing the first phone number available for a contact, or empty if the contact doesn't have any phone numbers associated.
     
     - version:
     1.0.0
     */
    public func getFirstPhoneNumber() -> String {
        let phoneNumbers = self.details.phoneNumbers
        return phoneNumbers.first?.value.stringValue ?? String()
    }
    
    /**
     Helper method to get the first email address available for the contact as string.
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns a string representing the first email address available for a contact, or empty if the contact doesn't have any email addresses associated.
     
     - version:
     1.0.0
     */
    public func getFirstEmailAddress() -> String {
        let emailAddresses = self.details.emailAddresses
        return String(emailAddresses.first?.value ?? "")
    }
    
    /**
     Helper method to find out if current date matches the contact's birthday.
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns a bool representing whether the today is the contact's birthday.
     
     - version:
     1.0.0
     */
    public func isBirthdayToday() -> Bool {
        let todayFormattedString = KNDatesUtils().string(from: Date(), format: .dayAndMonth)
        return self.formattedBirthday() == todayFormattedString
    }
    
    /**
     Helper method to find out if contact has an upcoming birthday in the following days.
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns a bool representing whether the today is the contact's birthday. False if the contact doesn't have birthday information available.
     
     - version:
     1.0.0
     */
    public func isBirthdayComing(in days: Int) -> Bool {
        let futureDate = Calendar.current.date(byAdding: .day, value: days, to: Date())!
        guard let birthday = self.birthday(currentYear: true) else {
            return false
        }
        
        return birthday.isBetween(Date(), and: futureDate) ? true : false
    }
    
    /**
     Helper method to find out if a contact's age.
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns an optional integer representing the contact's age if the birthday information including the year is available. Otherwise it returns nil.
     
     - version:
     1.0.0
     */
    public func getAge() -> Int? {
        guard self.details.birthday?.year != nil else { return nil }
        
        let components = Calendar.current.dateComponents([.year], from: birthday()!, to: Date())
        return components.year!
    }
    
    /**
     Helper method to retrieve a contact's upcoming birthday as an ordinal value e.g. If the contact is currently 29, it will return "30th".
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns an unwrapped String representing the contact's age at their next birthday as an ordinal if the birthday information including the year is available.
     
     - version:
     1.0.0
     */
    public func getAgeAsOrdinalAtNextBirthday() -> String! {
        guard self.getAge() != nil else { return String() }
        let ageAtNextBirthday = self.getAge()! + 1
        return ageAtNextBirthday.ordinal
    }
    
    /**
     Helper method to retrieve a contact's age on an upcoming birthday e.g. If the contact is currently 29, it will return "30".
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns an optional String representing the contact's age at their next birthday if the birthday information including the year is available.
     If the information isn't available it returns nil.
     
     - version:
     1.0.0
     */
    public func getAgeAtNextBirthday() -> String? {
        guard let age = self.getAge() else { return nil }
        return String(format: "%d", age.advanced(by: 1))
    }
    
    /**
     Helper method to retrieve a contact's current birthday as an ordinal value e.g. If the contact is currently 29, it will return "29th".
     
     - Author:
     dragosrobertn
     
     - returns:
     Returns an unwrapped String representing the contact's age as an ordinal if the birthday information including the year is available. Otherwise it returns nil.
     
     - version:
     1.0.0
     */
    public func getAgeAsOrdinal() -> String? {
       guard let age = self.getAge() else { return nil }
       return age.ordinal
    }
}

extension KNContact: Hashable { }

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
