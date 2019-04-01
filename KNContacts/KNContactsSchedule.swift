//
//  KNContactSchedule.swift
//  KINN
//
//  Created by Dragos-Robert Neagu on 16/02/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

public struct KNContactsSchedule {
    
    public let name: String
    public let format: KNTimeFormat
    private var schedule: [String: [String]] = [:]
    
    public init(name: String, format: KNTimeFormat = .fullDate) {
        self.name = name
        self.format = format
    }
    
    public mutating func add(list: [String], to day: Date) {
        let date = KNDatesUtils().string(from: day, format: format)
        self.schedule[date] = list
    }
    
    public mutating func add(list: [String], fromString day: String) {
        guard let date = KNDatesUtils().formatter(with: self.format).date(from: day) else {
            return
        }
        let conformedDate = KNDatesUtils().string(from: date, format: self.format)
        self.schedule[conformedDate] = list
    }
    
    public func getSchedule() -> [String: [String]] {
        return self.schedule
    }
    
    public func getSchedule(for day: Date) -> [String] {
        let date = KNDatesUtils().string(from: day, format: format)
        guard let daySchedule = self.schedule[date] else { return [] }
        return daySchedule
    }
    
    public func scheduleForToday() -> [String] {
        return self.getSchedule(for: Date())
    }
    
    public mutating func reset() {
        self.schedule.removeAll()
    }
}
