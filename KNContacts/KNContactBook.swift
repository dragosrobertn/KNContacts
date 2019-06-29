//
//  ContactBook.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 01/02/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

public class KNContactBook {
    
    public var id: String
    private var entries: [String: KNContact] = [:]
    
    public init(id: String) {
        self.id = id
    }
    
    public func reset() {
        self.entries = [:]
    }
    
    public func add(_ contact: KNContact) {
        self.entries[contact.id] = contact
    }
    
    public func add(_ contact: KNContact, id: String) {
        self.entries[id] = contact
    }
    
    public func add(_ contacts: [KNContact]) {
        contacts.forEach({ contact in self.add(contact) })
    }
    
    public func remove(_ id: String) {
        guard (self.entries.removeValue(forKey: id) != nil) else { return }
    }
    
    public func remove(_ contact: KNContact) {
        guard (self.entries.removeValue(forKey: contact.id) != nil) else { return }
    }
    
    public func remove(_ contacts: [KNContact]) {
        contacts.forEach({ contact in self.remove(contact) })
    }
    
    public func get(forKey: String) -> KNContact {
        return self.entries[forKey]!
    }
    
    public func getOptional(forKey: String) -> KNContact? {
        guard let entry = self.entries[forKey] else { return nil }
        return entry
    }
    
    public func toArray() -> [KNContact] {
        return Array(self.entries.values)
    }
    
    public func toArray(orderedBy orderingFunction: (KNContact, KNContact) -> Bool ) -> [KNContact] {
        return self.toArray().sorted(by: orderingFunction)
    }
    
    public func keysArray() -> [String] {
        return self.entries.values.compactMap { self.getOptional(forKey: $0.id)?.id }
    }
    
    public func randomElements(number: Int, except: [KNContact] = []) -> [KNContact] {
        var differenceList = self.toArray().difference(from: except)
        
        guard number < differenceList.count else { return differenceList }
        
        var randomArray: [KNContact] = [KNContact]()
        
        for _ in 1...number {
            guard let randomElement = differenceList.randomItem() else { break }
            randomArray.append(randomElement)
            differenceList = differenceList.difference(from: [randomElement])
        }
        
        return randomArray
    }
    
    public func updatedValues(for contactsArray: [KNContact]) -> [KNContact] {
        return contactsArray.map { self.entries[$0.id]! }
    }
    
    public func contains(element: KNContact) -> Bool {
        return self.keysArray().contains(element.id)
    }

}
