//
//  KNContact.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 25/01/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import UIKit

/**
KNContact class is a wrapper class which gives quick access to helper methods for a `CNContact`, like their full name,
birthday and age information, first email address or phone number.
 
- Author: dragosrobertn
- Version: 1.2.2
**/
public struct KNContact {
    
    /// Quick access to the contacts identifier.
    public var id: String { return self.info.identifier }
    
    /// A `CNContact` object representing the wrapped contact information.
    public var info: CNContact
    
    /// List of email addresses
    private var emails: [String] { return self.info.emailAddresses.compactMap { String($0.value) } }
    
    /// List of phone numbers
    private var phoneNumbers: [String] {
        return self.info.phoneNumbers.compactMap { String($0.value.stringValue) }
    }
    private var birthday: DateComponents? { return self.info.birthday }
    private let calendar = Calendar.current
    
    /**
     Initialises a `KNContact` object by wrapping a CNContact.
     
     - Author: dragosrobertn
     - Parameters:
        - contact: A CNContact.
     
     - Version: 1.0.0
     */
    public init(for contact: CNContact) {
        self.info = contact
    }
    
    /**
     Initialises a `KNContact` object by wrapping a CNContact.
     
     - Author: dragosrobertn
     - Parameters:
        - contact: A CNContact.
     
     - Version: 1.0.2
     */
    public init(_ contact: CNContact) {
        self.info = contact
    }

    /**
    Returns the full name of contacts using a formatting style (fullName or phoneticFullName).
     
     - Author: dragosrobertn
     - Parameters:
        - format: A CNContactFormatterStyle enum option. Optional. Defaults to .fullName
     
     - Returns: A string representing the full name. It can be an empty string.
     - Version: 1.2.1
     */
    public func fullName(format: CNContactFormatterStyle = .fullName) -> String {
        return CNContactFormatter.string(from: self.info, style: format) ?? ""
    }

    
    /**
     Returns the birthday of the contact as an optional date, if the contact has birthday information is available.
     
     - Author: dragosrobertn
     - Parameters:
        - forCurrentYear: A boolean value representing if the birthday date should be returned for the current year. Optional. Defaults to false.
     
     - Returns: A date representing the contact's birthday or nil.
     - Version: 1.1.0
     */
    public func getBirthday(forCurrentYear: Bool = false) -> Date? {
        guard let day = self.birthday?.day, let month = self.birthday?.month else {
            return nil
        }
        
        var components = DateComponents(month: month, day: day)
        
        if self.birthday?.year != nil {
            components.year = self.birthday?.year
        }
        
        if (forCurrentYear) {
            components.year = calendar.component(.year, from: Date())
        }
        
        return calendar.date(from: components)!
    }

    /**
     Helper method to return a formatted birthday using a `KNTimeFormat`.
     
     - Author: dragosrobertn
     - Parameters:
         - with: A `KNTimeFormat` enum option. Optional. Defaults to `KNTimeFormat.dayAndMonth`
         - forCurrentYear: A boolean value representing if the birthday date should be returned for the current year. Optional. Defaults to false.
     
     - Returns: Returns a string representing a formatted birthday using the `KNTimeFormat` passed. If the contact doesn't contain birthday information returns an empty string.
     - Version: 1.1.0
     */
    public func formatBirthday(with format: KNDateTimeFormat = .dayAndMonth,
                           forCurrentYear : Bool = false) -> String {
        return self.formatBirthday(with: format.rawValue, forCurrentYear: forCurrentYear)
    }

    
    /**
     Helper method to return a formatted birthday using a string representing a date formatt.
     
     - Author: dragosrobertn
     - Parameters:
         - with: A string representing the date format desired to display the birthday. Required.
         - forCurrentYear: A boolean value representing if the birthday date should be returned for the current year. Optional. Defaults to false.
     
     - Returns:
        Returns a string representing a formatted birthday using the format string passed.
        If the format is invalid or the contact doesn't contain birthday information returns an empty string.
     - Version: 1.1.0
     */
    public func formatBirthday(with format: String,
                           forCurrentYear: Bool = false) -> String {
        guard let date = self.getBirthday(forCurrentYear: forCurrentYear) else { return String() }
        return KNDatesUtils.string(from: date, format: format)
    }
    
    /**
     Helper method to get the first phone number available for the contact as string.
     
     - Author: dragosrobertn
     - Returns: Returns a string representing the first phone number available for a contact, or empty if the contact doesn't have any phone numbers associated.
     - Version: 1.1.0
     */
    public func getFirstPhoneNumber() -> String {
        return self.phoneNumbers.first ?? String()
    }
    
    /**
     Helper method to get the first email address available for the contact as string.
     
     - Author: dragosrobertn
     - Returns: Returns a string representing the first email address available for a contact, or empty if the contact doesn't have any email addresses associated.
     - Version: 1.1.0
     */
    public func getFirstEmailAddress() -> String {
        return self.emails.first ?? String()
    }
    
    /**
     Helper method to find out if current date matches the contact's birthday.
     
     - Author: dragosrobertn
     - Returns: Returns a boolean value representing whether current date is the contact's birthday.
     - Version: 1.0.0
     */
    public func isBirthdayToday() -> Bool {
        return self.birthdayMatches(date: Date())
    }
    
    /**
     Helper method to find out if current date matches the contact's birthday.
     
     - Author: dragosrobertn
     - Parameters:
        - date: The date to which to compare the contact's birthday
     - Returns: Returns a boolean value representing whether the passed date matches the contact's birthday
     - Version: 1.2.2
     */
    public func birthdayMatches(date: Date) -> Bool {
        let formattedDate = KNDatesUtils.string(from: date, format: .dayAndMonth)
        return self.formatBirthday() == formattedDate
    }
    
    /**
     Helper method to find out if contact has an upcoming birthday in the following days.
     
     - Author: dragosrobertn
     - Parameters:
        - in: The number of days as an integer representing the number of days to check if the birthday is upcoming
        - startingDate: The date from which to start checking if the birthday is upcoming. Default is today's date and the starting date will be excluded..
     
     - Returns: Returns a bool representing whether the contact's birthday is in the interval between the starting date and the number of following days provided by the days param.
                False if the contact doesn't have birthday information available.
     - Version: 1.2.1
     */
    public func isBirthdayComing(in days: Int, startingDate: Date = Date()) -> Bool {
        guard let birthday = self.getBirthday(forCurrentYear: true) else { return false }
        let birthdayComponents = calendar.dateComponents([.day, .month], from: birthday)
        let dateComponents: [DateComponents] = (1...days)
            .compactMap({ number in return calendar.date(byAdding: .day, value: number, to: startingDate)! })
            .compactMap({ date in return calendar.dateComponents([.day, .month], from: date)})
        
        return dateComponents.contains(birthdayComponents)
    }
    
    /**
     Helper method to find out if a contact's age.
     
     - Author: dragosrobertn
     - Returns:
        Returns an optional integer representing the contact's age if the birthday information including the year is available.
        Otherwise it returns nil.
     - Version: 1.1.0
     */
    public func getAge(atNextBirthday: Bool = false) -> Int? {
        guard self.info.birthday?.year != nil else { return nil }
        
        let age = calendar.dateComponents([.year], from: getBirthday()!, to: Date()).year!
        return atNextBirthday ? age.advanced(by: 1) : age
    }
    
    /**
     Helper method to retrieve a contact's age as string with option for current or turning age and an ordinal value e.g.
     If the contact is currently 29, it will return "29" for current age, "30" for age at next birthday and "30th" if ordinal representation.
     
     - Author: dragosrobertn
     - Returns:
     Returns an unwrapped String representing the contact's age as an ordinal if the birthday information including the year is available.
     Otherwise it returns nil.
     - Version: 1.1.0
     */
    public func getAgeAsString(atNextBirthday: Bool = false, asOrdinal: Bool = false) -> String! {
        guard let age = self.getAge(atNextBirthday: atNextBirthday) else { return String() }
        
        return asOrdinal ? age.ordinal :  String(format: "%d", age)
    }

}

extension KNContact: Hashable { }

extension KNContact: Comparable {
    /// Implementation of Comparable protocol, by comparing the contact identifiers
    public static func < (lhs: KNContact, rhs: KNContact) -> Bool {
        return lhs.id < rhs.id
    }
}

extension KNContact: Equatable {
    /// Implementation of Equatable protocol, by checking if the contact identifiers match
    public static func == (lhs: KNContact, rhs: KNContact) -> Bool {
        return lhs.id == rhs.id
    }
}
