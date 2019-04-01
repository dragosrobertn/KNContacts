//
//  DatesUtils.swift
//  KINN
//
//  Created by Dragos-Robert Neagu on 20/12/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

public struct KNDatesUtils {
    
    public init() {}
    
    public func formatter(with format: KNTimeFormat) -> DateFormatter {
        return self.formatter(with: format.rawValue)
    }
    
    public func formatter(with format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter
    }
    
    public func string(from date: Date, format: KNTimeFormat) -> String {
        return self.string(from: date, format: format.rawValue)
    }
    
    public func string(from date: Date, format: String) -> String {
        return self.formatter(with: format).string(from: date)
    }
    
}
