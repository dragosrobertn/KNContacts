//
//  ContactBookTests.swift
//  KINNUnitTests
//
//  Created by Dragos-Robert Neagu on 30/11/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import XCTest

class KNContactBookTests: XCTestCase {
    
    let contactBook = KNContactBook(with: "com.dragosneagu.Contact Book For Tests")
    var mutableContactsArray: [KNContact] = []
    var contactIDsArray: [String] = []

    override func setUp() {
        super.setUp()
        for _ in 1...3 {
            let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
            self.mutableContactsArray.append(contact)
            self.contactIDsArray.append(contact.id)
            
            contactBook.add(contact)
        }
    }
    
    func testCorrectlyCreatesContactBookWithName() {
        XCTAssertEqual(contactBook.id, "com.dragosneagu.Contact Book For Tests")
    }

    func testCorrectlyCountsHowManyContactsAreInTheContactBook() {
        XCTAssertEqual(contactBook.keysArray().count, 3)
    }
    
    func testCorrectlyResetsContacts() {
        contactBook.reset()
        XCTAssertEqual(contactBook.keysArray().count, 0)
    }
    
    func testAddsAndRetrievesAnotherContactToContactBook() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        let id = mutableContact.identifier
        
        contactBook.add(contact)
        
        XCTAssertEqual(contactBook.toArray().count, 4)
        XCTAssertEqual(contactBook.get(forKey: id).details, mutableContact)
    }
    
    func testAddsWithIDAndRetrievesAnotherContactToContactBook() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        let id = mutableContact.identifier
        
        contactBook.add(contact, id: contact.id)
        
        XCTAssertEqual(contactBook.toArray().count, 4)
        XCTAssertEqual(contactBook.get(forKey: id).details, mutableContact)
    }
    
    func testAddsAndRemovesAnotherContactFromContactBook() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        
        contactBook.add(contact)
        
        XCTAssertEqual(contactBook.toArray().count, 4)
        
        contactBook.remove(contact)
        XCTAssertEqual(contactBook.toArray().count, 3)
        XCTAssertFalse(contactBook.contains(element: contact))
    }
    
    func testAddsAndRemovesAnotherContactByIDFromContactBook() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        
        contactBook.add(contact, id: "custom-id")
        
        XCTAssertEqual(contactBook.toArray().count, 4)
        
        contactBook.remove("custom-id")
        XCTAssertEqual(contactBook.toArray().count, 3)
        XCTAssertFalse(contactBook.contains(element: contact))
    }
    
    func testAddsAndRemovesContactsArrayFromContactBook() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        
        contactBook.add([contact])
        
        XCTAssertEqual(contactBook.toArray().count, 4)
        
        contactBook.remove([contact])
        XCTAssertEqual(contactBook.toArray().count, 3)
        XCTAssertFalse(contactBook.contains(element: contact))
    }
    
    func testFailsToRemoveContactFromContactBookWhenIdDoesntExist() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        contactBook.remove(contact)
        XCTAssertEqual(contactBook.toArray().count, 3)
    }
    
    func testCanRetrieveContactFromContactBookIfUnsureItExists() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        let id = mutableContact.identifier
        
        contactBook.add(contact)
        
        XCTAssertEqual(contactBook.toArray().count, 4)
        XCTAssertEqual(contactBook.getOptional(forKey: id)!.details, contact.details)
    }
    
    func testReturnsNilWhenRetrievalWithContactFromContactBookIfUnsureItExists() {
        XCTAssertNil(contactBook.getOptional(forKey: "inexistent"))
    }
    
    func testItCorrectlyReturnsEntriesAsArray() {
        XCTAssertTrue(contactBook.toArray().containsSameElements(as: mutableContactsArray))
    }
    
    func testItReturnsEntriesKeysAsArray() {
        XCTAssertTrue(contactBook.keysArray().containsSameElements(as: contactIDsArray))
    }
    
    func testCorrectlyReturnTrueIfItContainsElement() {
        XCTAssertTrue(contactBook.contains(element: mutableContactsArray.randomItem()!))
    }
    
    func testCorrectlyReturnFalseIfItDoesntContainElement() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        let contact = KNContact(for: mutableContact)
        XCTAssertFalse(contactBook.contains(element: contact))
    }
    
    func testReturnsAllCurrentElementsAtRandomWhenNotEnoughElements() {
        let allCurrentElements = contactBook.randomElements(number: 3)
        XCTAssertTrue(allCurrentElements.containsSameElements(as: contactBook.toArray()))
    }
    
    func testRetrievesNumberOfRandomContacts() {
        for _ in 1...10 {
            let randomContacts = contactBook.randomElements(number: 2)
            
            XCTAssertEqual(randomContacts.count, 2)
            for contact in randomContacts {
                XCTAssertTrue(contactBook.contains(element: contact))
            }
        }
    }
    
    func testRetrievesNumberOfRandomContactsWithoutTheExistingOnes() {
        var newlyAddedContact: [KNContact] = []
        for _ in 1...10 {
            let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
            newlyAddedContact.append(contact)
            contactBook.add(contact)
        }
        
        for _ in 1...10 {
            let contact = newlyAddedContact.randomElement()
            var exceptionsList = mutableContactsArray
            exceptionsList.append(contact!)
            
            let randomContact = contactBook.randomElements(number: 3, except: exceptionsList)
            XCTAssertFalse(randomContact.isEmpty)
            XCTAssertFalse(randomContact.containsSameElements(as: exceptionsList))
        }
    }
    
    func testRetrivesContactsSortedByOrderOfBirthdays() {
        let january1stContact = UnitTestsContactHelpers.getMutableContact()
        january1stContact.birthday = DateComponents(calendar: Calendar.current, year: 1990, month: 01, day: 01)
        
        let january26thContact = UnitTestsContactHelpers.getMutableContact()
        january26thContact.birthday = DateComponents(calendar: Calendar.current, year: 1990, month: 01, day: 26)
        
        let february8thContact = UnitTestsContactHelpers.getMutableContact()
        february8thContact.birthday = DateComponents(calendar: Calendar.current, year: 1990, month: 02, day: 08)
        
        let december2ndContact = UnitTestsContactHelpers.getMutableContact()
        december2ndContact.birthday = DateComponents(calendar: Calendar.current, year: 1990, month: 12, day: 02)
        
        self.contactBook.reset()
        
        for contactWithBirthday in [february8thContact, january26thContact, december2ndContact, january1stContact] {
            let contact = KNContact(for: contactWithBirthday)
            self.mutableContactsArray.append(contact)
            self.contactIDsArray.append(contact.id)
            
            contactBook.add(contact)
        }
        
        let order = KNContactBookOrdering().thisYearsBirthday
        let arrayWithContactsSortedByBirthday = contactBook.toArray(orderedBy: order)
        
        XCTAssertEqual(arrayWithContactsSortedByBirthday[0].details, january1stContact)
        XCTAssertEqual(arrayWithContactsSortedByBirthday[1].details, january26thContact)
        XCTAssertEqual(arrayWithContactsSortedByBirthday[2].details, february8thContact)
        XCTAssertEqual(arrayWithContactsSortedByBirthday[3].details, december2ndContact)
    }
    
    func testRetrivesContactsSortedByOrderFullName() {
        let contactFamilyNameZ = UnitTestsContactHelpers.getMutableContact()
        contactFamilyNameZ.familyName = "Zaid"
        
        let contactFamilyNameA = UnitTestsContactHelpers.getMutableContact()
        contactFamilyNameA.familyName = "Adam"
        
        let contactFamilyNameD = UnitTestsContactHelpers.getMutableContact()
        contactFamilyNameD.familyName = "Daniel"
        
        let contactFamilyNameAGivenNameG = UnitTestsContactHelpers.getMutableContact()
        contactFamilyNameAGivenNameG.familyName = "Ari"
        contactFamilyNameAGivenNameG.givenName = "G"
        
        
        self.contactBook.reset()
        
        for contactWithGivenName in [contactFamilyNameZ, contactFamilyNameA, contactFamilyNameAGivenNameG, contactFamilyNameD] {
            let contact = KNContact(for: contactWithGivenName)
            self.mutableContactsArray.append(contact)
            self.contactIDsArray.append(contact.id)
            
            contactBook.add(contact)
        }
        
        let order = KNContactBookOrdering().fullName
        let arrayWithContactsSortedByBirthday = contactBook.toArray(orderedBy: order)
        
        XCTAssertEqual(arrayWithContactsSortedByBirthday[0].details, contactFamilyNameAGivenNameG)
        XCTAssertEqual(arrayWithContactsSortedByBirthday[1].details, contactFamilyNameA)
        XCTAssertEqual(arrayWithContactsSortedByBirthday[2].details, contactFamilyNameD)
        XCTAssertEqual(arrayWithContactsSortedByBirthday[3].details, contactFamilyNameZ)
    }
    
    func testRetrievesUpdatedContacts() {
        let mutableContact = UnitTestsContactHelpers.getMutableContact()
        mutableContact.familyName = "Old Family Name"
        let contact = KNContact(for: mutableContact)
        
        contactBook.add(contact)
        
        var retrievedContacts = self.contactBook.updatedValues(for: [contact])
        
        XCTAssertEqual(retrievedContacts.first, contact)
        
        mutableContact.familyName = "New Family Name"
        let updatedContact = KNContact(for: mutableContact)

        contactBook.add(updatedContact)

        retrievedContacts = contactBook.updatedValues(for: [updatedContact])
        XCTAssertEqual(retrievedContacts.first, updatedContact)
        XCTAssertTrue(retrievedContacts.first?.details.familyName == "New Family Name")
    }
}
