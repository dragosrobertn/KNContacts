//
//  KNDatesUtilsTests.swift
//  KNContactsTests
//
//  Created by Dragos-Robert Neagu on 11/06/2019.
//  Copyright © 2019-2020 Dragos-Robert Neagu. All rights reserved.
//

import XCTest

class KNDatesUtilsTests: XCTestCase {
    let invalidDateFormat = "invalid_date_format"
    let dateComponents = DateComponents(calendar: Calendar.current, year: 1990, month: 01, day: 01, hour: 19, minute: 38, second: 21)
    
    func testCorrectlyCreatesADateFormatterObjectWhenPassedAKNTimeFormat() {
        let dateStringFormmater = KNDatesUtils.formatter(with: KNTimeFormat.fullDate)
        XCTAssertNotNil(dateStringFormmater)
        XCTAssertEqual(dateStringFormmater.dateFormat!, KNTimeFormat.fullDate.rawValue)
    }
    
    func testCorrectlyCreatesADateFormatterObjectWhenPassedAStringDateFormat() {
        let dateStringFormmater = KNDatesUtils.formatter(with: "MMMM")
        XCTAssertNotNil(dateStringFormmater)
        XCTAssertEqual(dateStringFormmater.dateFormat!, "MMMM")
    }
    
    func testCorrectlyCreatesADateFormatterObjectWhenPassedAnInvalidDateFormat() {
        let dateStringFormmater = KNDatesUtils.formatter(with: invalidDateFormat)
        XCTAssertNotNil(dateStringFormmater)
        XCTAssertEqual(dateStringFormmater.dateFormat!, invalidDateFormat)
    }
    
    func testReturnsNilIfItCantParseADate() {
        let dateStringFormmater = KNDatesUtils.formatter(with: invalidDateFormat)
        XCTAssertNil(dateStringFormmater.date(from: "2019-01-01"))
    }
    
    func testReturnsACorrectStringFormattedUsingAKNTimeFormatFullDate() {
        XCTAssertEqual(KNDatesUtils.string(from: dateComponents.date!, format: .fullDate), "1990-01-01")
    }
    
    func testReturnsACorrectStringFormattedUsingAKNTimeFormatDayAndFullMonth() {
        let localisedDate = UnitTestsContactHelpers.getLocalisedStringFor("1 January", locale: Locale.current)
        XCTAssertEqual(KNDatesUtils.string(from: dateComponents.date!, format: .dayAndFullMonth), localisedDate)
    }
    
    func testReturnsACorrectStringFormattedUsingAKNTimeFormatFullMonth() {
        let localisedDate = UnitTestsContactHelpers.getLocalisedStringFor("January", locale: Locale.current)
        XCTAssertEqual(KNDatesUtils.string(from: dateComponents.date!, format: .fullMonth), localisedDate)
    }
    
    func testReturnsACorrectStringFormattedUsingAKNTimeFormatDayAndMonth() {
        let localisedDate = UnitTestsContactHelpers.getLocalisedStringFor("1 Jan", locale: Locale.current)
        XCTAssertEqual(KNDatesUtils.string(from: dateComponents.date!, format: .dayAndMonth), localisedDate)
    }
    
    func testReturnsACorrectStringFormattedUsingAKNTimeFormatHourAndMinutes() {
        XCTAssertEqual(KNDatesUtils.string(from: dateComponents.date!, format: .hourAndMinutes), "19:38")
    }
    
    func testReturnsACorrectStringFormattedUsingAKNTimeFormatTimestamp() {
        XCTAssertEqual(KNDatesUtils.string(from: dateComponents.date!, format: .timeStamp), "1990-01-01 19:38")
    }
    
    func testReturnsACorrectStringFormattedUsingACustomDateTimeStringFormatAsFullTimestamp() {
        XCTAssertEqual(KNDatesUtils.string(from: dateComponents.date!, format: "YYYY-MM-DD HH:mm:ss"), "1990-01-01 19:38:21")
    }
    
    func testReturnsEmptyStringIfItCantReturnStringForInvalidFormat() {
        XCTAssertEqual(KNDatesUtils.string(from: Date(), format: invalidDateFormat), "")
    }

}
