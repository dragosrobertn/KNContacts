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
- Version: 1.1.0
**/
public struct KNContact {
    
    /// Quick access to the contacts identifier.
    public var id: String { return self.info.identifier }
    
    /// A `CNContact` object representing the wrapped contact information.
    public var info: CNContact
    /**
    A `CNContact` object representing the wrapped contact information.
     - Warning: Deprecated. Use 'KNContact.info' property instead.
    **/
    @available(*, deprecated, message: "Use 'KNContact.info' property instead.")
    public var details: CNContact { return self.info }
    
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
     - Version: 1.0.2
     */
    public func fullName(format: CNContactFormatterStyle = .fullName) -> String {
        guard let name = CNContactFormatter.string(from: self.info, style: format) else { return "" }
        return name
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
     - Returns: Returns a boolean value representing whether the today is the contact's birthday.
     - Version: 1.0.0
     */
    public func isBirthdayToday() -> Bool {
        let todayFormattedString = KNDatesUtils.string(from: Date(), format: .dayAndMonth)
        return self.formatBirthday() == todayFormattedString
    }
    
    /**
     Helper method to find out if contact has an upcoming birthday in the following days.
     
     - Author: dragosrobertn
     - Parameters:
        - in: The number of days as an integer representing the number of days to check if the birthday is upcoming
     
     - Returns: Returns a bool representing whether the today is the contact's birthday. False if the contact doesn't have birthday information available.
     - Version: 1.0.0
     */
    public func isBirthdayComing(in days: Int) -> Bool {
        let futureDate = calendar.date(byAdding: .day, value: days, to: Date())!
        guard let birthday = self.getBirthday(forCurrentYear: true) else {
            return false
        }
        
        return birthday.isBetween(Date(), and: futureDate) ? true : false
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

extension KNContact {

    /**
     Returns the birthday of the contact as an optional date, if the contact has birthday information is available.
     
     - Author: dragosrobertn
     - Parameters:
     - forCurrentYear:
     A boolean value representing if the birthday date should be returned for the current year.
     Optional. Defaults to false.
     
     - Returns: A date representing the contact's birthday or nil.
     - Version: 1.0.0
     - Warning: Deprecated. Use 'getBirthday(forCurrentYear:)' instead.'
     */
    @available(*, deprecated, message: "Use 'getBirthday(forCurrentYear:)' instead.'")
    public func birthday(currentYear: Bool = false) -> Date? {
        return self.getBirthday(forCurrentYear: currentYear)
    }
    
    /**
     Helper method to return a formatted birthday using a `KNTimeFormat`.
     
     - Author: dragosrobertn
     - Parameters:
     - with: A `KNTimeFormat` enum option. Optional. Defaults to `KNTimeFormat.dayAndMonth`
     - currentYear: A boolean value representing if the birthday date should be returned for the current year. Optional. Defaults to false.
     
     - Returns: Returns a string representing a formatted birthday using the `KNTimeFormat` passed. If the contact doesn't contain birthday information returns an empty string.
     - Version: 1.0.0
     - Warning: Use 'formatBirthday(with format: forCurrentYear:)' instead.
     */
    @available(*, deprecated, message: "Use 'formatBirthday(with format: forCurrentYear:)' instead.")
    public func formattedBirthday(with format: KNTimeFormat = .dayAndMonth,
                                  currentYear : Bool = false) -> String {
        return self.formatBirthday(with: format, forCurrentYear: currentYear)
    }
    
    /**
     Helper method to return a formatted birthday using a string representing a date formatt.
     
     - Author: dragosrobertn
     - Parameters:
     - with: A string representing the date format desired to display the birthday. Required.
     - currentYear:
     A boolean value representing if the birthday date should be returned for the current year.
     Optional. Defaults to false.
     
     - Returns:
     Returns a string representing a formatted birthday using the format string passed.
     If the format is invalid or the contact doesn't contain birthday information returns an empty string.
     - Version: 1.0.0
     - Warning: Deprecated. Use 'formatBirthday(with format: forCurrentYear:)' instead.
     */
    @available(*, deprecated, message: "Use 'formatBirthday(with format: forCurrentYear:)' instead.")
    public func formattedBirthday(with format: String,
                                  currentYear : Bool = false) -> String {
        return self.formatBirthday(with: format, forCurrentYear: currentYear)
    }
    
    /**
     Helper method to retrieve a contact's upcoming birthday as an ordinal value e.g. If the contact is currently 29, it will return "30th".
     
     - Author: dragosrobertn
     - Returns: Returns an unwrapped String representing the contact's age at their next birthday as an ordinal if the birthday information including the year is available.
     - Version: 1.0.0
     - Warning: Deprecated. Use 'getAgeAsString(atNextBirthday:asOrdinal)' instead.
     */
    @available(*, deprecated, message: "Use 'getAgeAsString(atNextBirthday:asOrdinal)' instead.")
    public func getAgeAsOrdinalAtNextBirthday() -> String! {
        return self.getAgeAsString(atNextBirthday: true, asOrdinal: true)
    }
    
    /**
     Helper method to retrieve a contact's age on an upcoming birthday e.g. If the contact is currently 29, it will return "30".
     
     - Author:dragosrobertn
     - Returns:
     Returns an optional String representing the contact's age at their next birthday if the birthday information including the year is available.
     If the information isn't available it returns nil.
     - Version: 1.0.0
     - Warning: Deprecated. Use 'getAgeAsString(atNextBirthday:asOrdinal)' instead.
     
     */
    @available(*, deprecated, message: "Use 'getAgeAsString(atNextBirthday:asOrdinal)' instead.")
    public func getAgeAtNextBirthday() -> String! {
        return self.getAgeAsString(atNextBirthday: true)
    }
    
    /**
     Helper method to retrieve a contact's current birthday as an ordinal value e.g. If the contact is currently 29, it will return "29th".
     
     - Author: dragosrobertn
     - Returns:
     Returns an unwrapped String representing the contact's age as an ordinal if the birthday information including the year is available.
     Otherwise it returns nil.
     - Version: 1.0.0
     - Warning: Deprecated. Use 'getAgeAsString(atNextBirthday:asOrdinal)' instead.
     */
    @available(*, deprecated, message: "Use 'getAgeAsString(atNextBirthday:asOrdinal)' instead.")
    public func getAgeAsOrdinal() -> String! {
        return self.getAgeAsString(asOrdinal: true)
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
