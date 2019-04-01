//
//  KNContactTests.swift
//  KINNUnitTests
//
//  Created by Dragos-Robert Neagu on 19/10/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Contacts
import XCTest

class KNContactTests: XCTestCase {
    
    func testKNContactIdIsSameAsContactIdentifier() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.id, contact.id)
    }
    
    func testKNContactGetsFullNameAsEmptyIfNameIsNil() {
        let mutableContact = CNMutableContact()
        let contact = KNContact(for: mutableContact)
        
        XCTAssertNil(CNContactFormatter.string(from: mutableContact, style: .fullName))
        XCTAssertEqual(contact.fullName(), "")
    }
    
    func testKNContactGetsFullName() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.fullName(), "John Smith")
    }
    
    func testKNContactGetsEmptyNameIfFullNameCannotBeConstructed() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.familyName = ""
        mutableContact.givenName = ""
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.fullName(), "")
    }
    
    // This needs adjusting for the any year...
    func testKNContactGetsBirthday() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.getAge(), 29)
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
        
        XCTAssertEqual(contact.getAgeAsOrdinalAtNextBirthday(), "")
    }
    
    func testKNContactGetsBirthdayAsOrdinalAtNextBirthday() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.getAgeAsOrdinalAtNextBirthday(), "30th")
    }
    
    func testKNContactGetsBirthdayAsOrdinal() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.getAgeAsOrdinal(), "29th")
    }
    
    func testKNContactGetsNilWhenBirthdayIsNilForAgeAsOrdinal() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertNil(contact.getAgeAsOrdinal())
    }
    
    func testIsBirthdayComingIsFalse() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertFalse(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayComingIsFalseWhenBirthdayIsNil() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertFalse(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayComingIsTrue() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let calendar = Calendar.current
        let aWeekFromToday = Calendar.current.date(byAdding: .day, value: 7, to: Date())!

        let todayComponents = calendar.dateComponents([.day, .month],
                                                      from: aWeekFromToday)
        mutableContact.birthday?.day = todayComponents.day
        mutableContact.birthday?.month = todayComponents.month
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact.isBirthdayComing(in: 7))
    }
    
    func testIsBirthdayTodayIsFalse() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertFalse(contact.isBirthdayToday())
    }
    
    func testIsBirthdayTodayIsTrue() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        
        let todayComponents = Calendar.current.dateComponents([.day, .month], from: Date())
        mutableContact.birthday?.day = todayComponents.day
        mutableContact.birthday?.month = todayComponents.month
        
        let contact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact.isBirthdayToday())
    }
    
    func testGetFirstEmailAddress() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
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
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
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
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.formattedBirthday(with: .fullDate, currentYear: false), "1990-01-01")
    }
    
    func testFormattedBirthdayReturnsEmptyStringWhenBirthdayIsNotPresentUsingFullDeclaration() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formattedBirthday(with: .fullDate, currentYear: false), "")
    }
    
    func testFormattedThisYearsBirthdayWithFullDate() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.formattedBirthday(with: .fullDate, currentYear: true), "2019-01-01")
    }
    
    func testFormatedThisYearsBirthdayReturnsEmptyStringWhenBirthdayIsNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formattedBirthday(with: .fullDate, currentYear: true), "")
    }
    
    func testFormattedBirthday() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.formattedBirthday(), "1 Jan")
    }
    
    func testFormattedBirthdayReturnsEmptyStringWhenBirthdayIsNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formattedBirthday(), "")
    }
    
    func testFormattedBirthdayWithCustomStringFormat() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertEqual(contact.formattedBirthday(with: "d MM"), "1 01")
    }
    
    func testFormattedBirthdayWithStringFormatReturnsEmptyStringWhenBirthdayIsNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formattedBirthday(with: "d MM"), "")
    }
    
    func testFormattedBirthdayReturnsEmptyStringFormatIdGibberish() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertEqual(contact.formattedBirthday(with: "gibberish"), "")
    }
    
    func testBirthdayAsDate() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        let dateComp = DateComponents(calendar: Calendar.current, year: 1990, month: 01, day: 01)
        
        XCTAssertEqual(contact.birthday(), dateComp.date)
    }
    
    func testBirthdayAsDateReturnNilWhenBirthdayNotPresent() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.birthday = nil
        let contact = KNContact(for: mutableContact)
        
        XCTAssertNil(contact.birthday())
    }
    
    func testKNContactsAreTheSame() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        let anotherKNContact = KNContact(for: mutableContact)
        
        XCTAssertTrue(contact == anotherKNContact)
    }
    
    func testKNContactsAreNotTheSame() {
        let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        let anotherKNContact = UnitTestsContactHelpers.getKNContactWithMutableContact()
        
        XCTAssertFalse(contact == anotherKNContact)
    }
}
