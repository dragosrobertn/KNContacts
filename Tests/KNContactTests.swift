//
//  KNContactTests.swift
//  KINNUnitTests
//
//  Created by Dragos-Robert Neagu on 19/10/2018.
//  Copyright © 2019-2020 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import KNContacts
import XCTest

class KNContactTests: XCTestCase {
    let currentYearMinus29Years = Calendar.current.dateComponents([.year], from:  Date()).year! - 29
    let calendar = Calendar.current
    func testKNContactIdIsSameAsContactIdentifier() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertEqual(contact.id, contact.id)
    }
    
    func testKNContactGetsFullNameAsEmptyIfNameIsNil() {
        let mutableContact = CNMutableContact()
        let contact = KNContact(for: mutableContact)
        
        XCTAssertNil(CNContactFormatter.string(from: mutableContact, style: .fullName))
        XCTAssertEqual(contact.fullName(), "")
    }
    
    func testKNContactGetsFullName() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertEqual(contact.fullName(), "John Smith")
    }
    
    func testKNContactGetsPhoneticFullName() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertEqual(contact.fullName(format: .phoneticFullName), "Jon")
    }
    
    func testKNContactGetsEmptyNameIfFullNameCannotBeConstructed() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.familyName = ""
        mutableContact.givenName = ""
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.fullName(), "")
    }
    
    func testKNContactGetsBirthday() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = currentYearMinus29Years
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getAge(), 29)
        XCTAssertEqual(contact.getAge(atNextBirthday: true), 30)
        XCTAssertEqual(contact.getAgeAsString(atNextBirthday: true), "30")
    }
    
    func testKNContactGetsAgeAtNextBirthdayReturnNilWhenDateNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getAgeAsString(atNextBirthday: true), "")
    }
    
    func testKNContactGetsNilWhenBirthdayNotAvailable() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertNil(contact.getAge())
    }
    
    func testKNContactGetsBirthdayAsOrdinalAtNextBirthdayIsEmptyStringWhenBirthdayIsNil() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getAgeAsString(atNextBirthday: true, asOrdinal: true), "")
    }
    
    func testKNContactGetsBirthdayAsOrdinalAtNextBirthday() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = currentYearMinus29Years
        let contact = KNContact(mutableContact)
        
        let localisedAge = UnitTestsContactHelpers.getLocalisedStringFor("30th", locale: Locale.current)
        
        XCTAssertEqual(contact.getAgeAsString(atNextBirthday: true, asOrdinal: true), localisedAge)
    }
    
    func testKNContactGetsBirthdayAsOrdinal() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = currentYearMinus29Years
        let contact = KNContact(mutableContact)
        
        let localisedAge = UnitTestsContactHelpers.getLocalisedStringFor("29th", locale: Locale.current)
        
        XCTAssertEqual(contact.getAgeAsString(atNextBirthday: false, asOrdinal: true), localisedAge)
    }
    
    func testKNContactGetsEmptyWhenBirthdayIsEmptyForAgeAsOrdinal() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getAgeAsString(asOrdinal: true), "")
    }
    
    func testIsBirthdayComingIsFalse() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!

        let yesterdayTodayComponents = calendar.dateComponents([.day, .month], from: yesterday)
        mutableContact.birthday?.day = yesterdayTodayComponents.day
        mutableContact.birthday?.month = yesterdayTodayComponents.month

        let contact = KNContact(for: mutableContact)
        
        XCTAssertFalse(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayComingIsFalseWhenBirthdayIsNil() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertFalse(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayComingIsFalseWhenBirthdayIsToday() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        
        let todayComponents = calendar.dateComponents([.day, .month], from: Date())
        mutableContact.birthday?.day = todayComponents.day
        mutableContact.birthday?.month = todayComponents.month
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertFalse(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayComingIsTrue() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let aWeekFromToday = calendar.date(byAdding: .day, value: 7, to: Date())!

        let aWeekFromTodayComponents = calendar.dateComponents([.day, .month],
                                                      from: aWeekFromToday)
        mutableContact.birthday?.day = aWeekFromTodayComponents.day
        mutableContact.birthday?.month = aWeekFromTodayComponents.month
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayComingIsTrueForContactWithAllDateComponents() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let aWeekFromToday = calendar.date(byAdding: .day, value: 7, to: Date())!

        let aWeekFromTodayComponents = calendar.dateComponents([.day, .month, .year],
                                                      from: aWeekFromToday)
        mutableContact.birthday?.day = aWeekFromTodayComponents.day
        mutableContact.birthday?.month = aWeekFromTodayComponents.month
        mutableContact.birthday?.year = aWeekFromTodayComponents.year
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayComingIsTrueForContactWithBirthdayInLateDecemberWhichMakesTheCheckPassAYear() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.day = 28
        mutableContact.birthday?.month = 12
        
        let dateUtilsFormatter = KNDatesUtils.formatter(with: .fullDate)
        let todayDate = dateUtilsFormatter.date(from: "2019-12-27")
        
        let contact = KNContact(for: mutableContact)
        XCTAssertTrue(contact.isBirthdayComing(in: 7, startingDate: todayDate!))
    }
    
    func testIsBirthdayComingIsFalseForContactWithBirthdayInLateDecemberThatJustPassedWhichMakesTheCheckPassAYear() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.day = 27
        mutableContact.birthday?.month = 12
        
        let dateUtilsFormatter = KNDatesUtils.formatter(with: .fullDate)
        let todayDate = dateUtilsFormatter.date(from: "2019-12-27")
        
        let contact = KNContact(for: mutableContact)
        XCTAssertFalse(contact.isBirthdayComing(in: 7, startingDate: todayDate!))
    }
    
    func testIsBirthdayComingIsTrueForContactWithBirthdayInLeapYear() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.day = 29
        mutableContact.birthday?.month = 02
        
        let dateUtilsFormatter = KNDatesUtils.formatter(with: .fullDate)
        let todayDate = dateUtilsFormatter.date(from: "2020-02-22")
        
        let contact = KNContact(for: mutableContact)
        XCTAssertTrue(contact.isBirthdayComing(in: 7, startingDate: todayDate!))
    }
    
    func testIsBirthdayTodayIsFalse() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertFalse(contact.isBirthdayToday())
    }
    
    func testIsBirthdayTodayIsTrue() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        
        let todayComponents = calendar.dateComponents([.day, .month], from: Date())
        mutableContact.birthday?.day = todayComponents.day
        mutableContact.birthday?.month = todayComponents.month
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact.isBirthdayToday())
    }
    
    func testBirthdayMatchesCurrentDateIsTrue() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        
        let today = Date()
        let todayComponents = calendar.dateComponents([.day, .month], from: today)
        mutableContact.birthday?.day = todayComponents.day
        mutableContact.birthday?.month = todayComponents.month
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact.birthdayMatches(date: today))
    }
    
    func testBirthdayMatchesTomorrowsDateIsFalse() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date())!
        let todayComponents = calendar.dateComponents([.day, .month], from: Date())
        mutableContact.birthday?.day = todayComponents.day
        mutableContact.birthday?.month = todayComponents.month
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertFalse(contact.birthdayMatches(date: tomorrow))
    }
    
    func testGetFirstEmailAddress() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertEqual(contact.getFirstEmailAddress(), "first")
        XCTAssertNotEqual(contact.getFirstEmailAddress(), "second")
    }
    
    func testGetFirstEmailAddressReturnEmptyStringWhenEmailAddressNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.emailAddresses = []
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getFirstEmailAddress(), "")
    }
    
    func testGetFirstPhoneNumber() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertEqual(contact.getFirstPhoneNumber(), "123456789")
        XCTAssertNotEqual(contact.getFirstPhoneNumber(), "987654321")
    }
    
    func testGetFirstPhoneNumberReturnEmptyStringWhenPhoneNumbersNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.phoneNumbers = []
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getFirstPhoneNumber(), "")
    }
    
    func testFormattedBirthdayWithFullDateForm() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertEqual(contact.formatBirthday(with: .fullDate, forCurrentYear: false), "1990-01-01")

    }
    
    func testFormattedBirthdayReturnsEmptyStringWhenBirthdayIsNotPresentUsingFullDeclaration() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formatBirthday(with: .fullDate, forCurrentYear: false), "")
    }
    
    func testFormattedThisYearsBirthdayWithFullDate() {
        let contact = UnitTestsContactHelpers.getKNContact()
        let currentYear = calendar.dateComponents([.year], from: Date()).year ?? 0
        XCTAssertEqual(contact.formatBirthday(with: .fullDate, forCurrentYear: true), "\(currentYear)-01-01")
    }
    
    func testFormatedThisYearsBirthdayReturnsEmptyStringWhenBirthdayIsNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formatBirthday(with: .fullDate, forCurrentYear: true), "")
    }
    
    func testFormattedBirthday() {
        let contact = UnitTestsContactHelpers.getKNContact()
        let localisedDate = UnitTestsContactHelpers.getLocalisedStringFor("1 Jan", locale: Locale.current)
        XCTAssertEqual(contact.formatBirthday(), localisedDate)
    }
    
    func testFormattedBirthdayReturnsEmptyStringWhenBirthdayIsNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formatBirthday(), "")
    }
    
    func testFormattedBirthdayWithCustomStringFormat() {
        let contact = UnitTestsContactHelpers.getKNContact()
        
        XCTAssertEqual(contact.formatBirthday(with: "d MM"), "1 01")
    }
    
    func testFormattedBirthdayWithStringFormatReturnsEmptyStringWhenBirthdayIsNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formatBirthday(with: "d MM"), "")
    }
    
    func testFormattedBirthdayReturnsEmptyStringFormatIdGibberish() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formatBirthday(with: "gibberish"), "")
    }
    
    func testBirthdayAsDate() {
        let contact = UnitTestsContactHelpers.getKNContact()
        let dateComp = DateComponents(calendar: Calendar.current, year: 1990, month: 01, day: 01)
        
        XCTAssertEqual(contact.getBirthday(), dateComp.date)
    }
    
    func testBirthdayAsDateReturnNilWhenBirthdayNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertNil(contact.getBirthday())
    }
    
    func testRetrievesEmptyStringAgeAsStringForWhenYearNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getAgeAsString(), "")
    }
    
    func testRetrievesCurrentAgeAsString() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = currentYearMinus29Years
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getAgeAsString(), "29")
    }
    
    func testRetrievesCurrentAgeOrdinalAsString() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = currentYearMinus29Years
        let contact = KNContact(for: mutableContact)
        
        let localisedAge = UnitTestsContactHelpers.getLocalisedStringFor("29th", locale: Locale.current)
        XCTAssertEqual(contact.getAgeAsString(asOrdinal: true), localisedAge)
    }
    
    func testRetrievesAgeAtNextBirthdayAsString() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = currentYearMinus29Years
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.getAgeAsString(atNextBirthday: true), "30")
    }
    
    func testRetrievesAgeOrdinalAtNextBirthdayAsString() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday?.year = currentYearMinus29Years
        let contact = KNContact(for: mutableContact)
        
        let localisedAge = UnitTestsContactHelpers.getLocalisedStringFor("30th", locale: Locale.current)
        
        XCTAssertEqual(contact.getAgeAsString(atNextBirthday: true, asOrdinal: true), localisedAge)
    }
    
    func testKNContactsAreTheSame() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        let anotherKNContact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact == anotherKNContact)
    }
    
    func testKNContactsAreNotTheSame() {
        let contact = UnitTestsContactHelpers.getKNContact()
        let anotherKNContact = UnitTestsContactHelpers.getKNContact()
        XCTAssertFalse(contact == anotherKNContact)
    }
}
