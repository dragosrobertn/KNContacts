//
//  KNContactScheduleTests.swift
//  KINNUnitTests
//
//  Created by Dragos-Robert Neagu on 16/02/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import XCTest

class KNContactScheduleTests: XCTestCase {
    
    let contactBook = KNContactBook(with: "com.dragosneagu.Contact Book For Tests")
    var favourites = KNContactsSchedule(name: "com.dragosneagu.schedule.favourites")
    var mutableContactsArray: [KNContact] = []
    var contactIDsArray: [String] = []
    
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    override func setUp() {
        super.setUp()
        for _ in 1...3 {
            let contact = UnitTestsContactHelpers.getKNContactWithMutableContact()
            self.mutableContactsArray.append(contact)
            self.contactIDsArray.append(contact.id)
            
            contactBook.add(contact)
        }
    }

    func testCorrectlyCreatesAContactSchedule() {
        XCTAssertTrue(favourites.name == "com.dragosneagu.schedule.favourites", "Schedule name is favourites")
        XCTAssertTrue(favourites.getSchedule().isEmpty, "Schedule is 0")
    }
    
    func testAddsADateToTheSchedule() {
        let date = Date()
        let list: [String] = []
        favourites.add(list: list, to: date)
        
        XCTAssertTrue(favourites.getSchedule().count == 1, "Schedule has a date entry")
        XCTAssertTrue(favourites.getSchedule(for: date) == [], "Schedule for date can be retrieved")
    }
    
    func testReturnsEmptyIfScheduleDoesntExist() {
        XCTAssertTrue(favourites.getSchedule(for: Date()).containsSameElements(as: []), "Schedule is empty")
    }
    
    func testAddsScheduleForDate() {
        let today = Date()
        let todayList = ["1", "2", "3"]
        let tomorrowList = ["4", "5"]
        
        favourites.add(list: todayList, to: today)
        favourites.add(list: tomorrowList, to: tomorrow)
        
        XCTAssertTrue(favourites.getSchedule().count == 2, "Schedule has 2 entries")
        XCTAssertTrue(favourites.scheduleForToday().containsSameElements(as: todayList),
                      "Schedule retrieves correct entries for today")
        XCTAssertTrue(favourites.getSchedule(for: tomorrow).containsSameElements(as: tomorrowList),
                      "Schedule retrieves correct entries for tomorrow")
    }
    
    func testResetScheduleForAllDates() {
        let today = Date()
        let todayList = ["1", "2", "3"]
        let tomorrowList = ["4", "5"]
        
        favourites.add(list: todayList, to: today)
        favourites.add(list: tomorrowList, to: tomorrow)
        
        XCTAssertTrue(favourites.getSchedule().count == 2, "Schedule has 2 entries")
        
        favourites.reset()
        
        XCTAssertTrue(favourites.getSchedule().isEmpty, "Schedule has 0 entries")
    }
}
