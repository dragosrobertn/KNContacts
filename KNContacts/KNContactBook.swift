//
//  ContactBook.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 01/02/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

import Foundation

/**
KNContactBook class is a collection of `KNContact` objects to help with
contact grouping, sorting and selecting random elements.
    
    - Author: dragosrobertn
    - Version: 1.0.0
**/
public class KNContactBook {
    
    /// The contact book identifier or name.
    public var id: String
    private var entries: [String: KNContact] = [:]
    
    /**
    Initialiser with an identifier representing a way to name or identify the contact book.
    
    - Author: dragosrobertn
    - Parameters:
     - id: A string identifier representing a unique identifier or name for the contact book.
    
    - Version: 1.0.0
    */
    public init(id: String) {
        self.id = id
    }
    
    /**
     Resets the contact book by invalidating the stored contact entries.
     
     - Author: dragosrobertn
     - Version: 1.0.0
     */
    public func reset() {
        self.entries = [:]
    }
    
    /**
    Appends a `KNContact` to the contact book, identified by the contacts identifier.
     
     - Author: dragosrobertn
     - Parameters:
        - contact: A `KNContact` object to be added to the contact book.
     
     - Version: 1.0.0
     */
    public func add(_ contact: KNContact) {
        self.entries[contact.id] = contact
    }
    
    /**
     Appends a `KNContact` to the contact book, identified with the passed id parameter
     
     - Author: dragosrobertn
     - Parameters:
        - contact: A `KNContact` object to be added to the contact book. Required.
        - id: A String representing a way to uniquely identify the contact to be added. Required.
     
     - Version: 1.0.0
     */
    public func add(_ contact: KNContact, id: String) {
        self.entries[id] = contact
    }
    
    /**
     Appends multiple `KNContact` object to the contact book, identified by the contacts identifiers.
     
     - Author: dragosrobertn
     - Parameters:
        - contacts: An array of `KNContact` object to be added to the contact book.
     
     - Version: 1.0.0
     */
    public func add(_ contacts: [KNContact]) {
        contacts.forEach({ contact in self.add(contact) })
    }
    
    /**
     Removes a `KNContact` from the contact book if it can find it in the contact book by the passed String identifier.
     
     - Author: dragosrobertn
     - Parameters:
        - id: A string value representing the unique identifier to attempt removal from the contact book.
     
     - Version: 1.0.0
     */
    public func remove(_ id: String) {
        guard (self.entries.removeValue(forKey: id) != nil) else { return }
    }
    
    /**
     Removes a `KNContact` from the contact book if it can find it in the contact book.
     
     - Author: dragosrobertn
     - Parameters:
        - contact: A `KNContact` object to attempt removal from the contact book.
     
     - Version: 1.0.0
     */
    public func remove(_ contact: KNContact) {
        guard (self.entries.removeValue(forKey: contact.id) != nil) else { return }
    }
    
    /**
     Removes multiple `KNContact`objects from the contact book if it can find them in the contact book.
     
     - Author: dragosrobertn
     - Parameters:
        - contacts: An array of `KNContact` objects to attempt removal from the contact book.
     
     - Version: 1.0.0
     */
    public func remove(_ contacts: [KNContact]) {
        contacts.forEach({ contact in self.remove(contact) })
    }
    
    /**
     Retrieves a `KNContact` from the contact book by using the passed key identifier.
     
     - Author: dragosrobertn
     - Parameters:
        - forKey: A `KNContact` object to be added to the contact book.
     
     - Returns: If found, it returns the `KNContact` object from the contact book. Otherwise nil.
     - Version: 1.0.1
     
     - Warning:
        This method force unwraps the value and it can return nil if asked to return an element that doesn't exist.
        If unsure if the KNContact exists in the contact book, use `KNContactBook().getOptional(forKey:)` instead.
     */
    public func get(forKey: String) -> KNContact! {
        return self.entries[forKey]
    }
    
    /**
     Retrieves a `KNContact` optional from the contact book by using the passed key identifier.
     
     - Author: dragosrobertn
     - Parameters:
        - forKey: A `KNContact` object to be added to the contact book.
     
     - Returns: If found, it returns the `KNContact` object from the contact book. Otherwise nil.
     - Version: 1.0.0
     
     */
    public func getOptional(forKey: String) -> KNContact? {
        guard let entry = self.entries[forKey] else { return nil }
        return entry
    }
    
    /**
     A method to return all stored contacts as an array.
     
     - Author: dragosrobertn
     - Returns: Returns an array of all `KNContact` objects in the contact book.
     - Version: 1.0.0
     */
    public func toArray() -> [KNContact] {
        return Array(self.entries.values)
    }
    
    /**
     A method to return all stored contacts as an array, sorted by a passed criteria.
     
     - Author: dragosrobertn
     - Parameters:
        - orderedBy:
            A closure of the following signature `(KNContact, KNContact) -> Bool` representing the criteris used to sort contact.
            Alternatively a `KNContactBookOrdering` helper value can be passed in.
     
     - Returns: Returns an array of all `KNContact` objects sorted by the passed ordering function in a the contact book.
     - Version: 1.0.0
     */
    public func toArray(orderedBy orderingFunction: (KNContact, KNContact) -> Bool ) -> [KNContact] {
        return self.toArray().sorted(by: orderingFunction)
    }
    
    /**
     A method to return all stored contact identifiers keys as an array.
     
     - Author: dragosrobertn
     - Returns: Returns an array of all `KNContact` identifiers.
     - Version: 1.0.0
     */
    public func keysArray() -> [String] {
        return self.entries.values.compactMap { self.getOptional(forKey: $0.id)?.id }
    }
    
    /**
     A method to return a number of random elements from the contact book.
     If the number of contacts in the contact book is lower than the requested number, or lower than the number after excluding
     the passed contact, it will return an array list of the rest of the available contacts, which count can be lower than requested
     or even empty.
     
     - Author: dragosrobertn
     - Parameters:
         - number: An integer representing the desired number of random elements. Required.
         - except:
            An array list of `KNContacts` to be excluded from being selected when choosing random contact.
            Optional. Defaults to including all contact.
     
     - Returns: Returns an array of randomly selected`KNContact` objects from the contact book.
     - Version: 1.0.0
     */
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
    
    /**
     Retrieve mutliple up to date contacts from the contact book.
     
     - Author: dragosrobertn
     - Parameters:
        - for: An array to `KNContact` objects to retrieve updated values.
     
     - Returns: Returns an array of the up to date values of `KNContact` objects from the contact book.
     - Version: 1.0.0
     */
    public func updatedValues(for contactsArray: [KNContact]) -> [KNContact] {
        return contactsArray.compactMap { self.get(forKey: $0.id) }
    }
    
    /**
     Checks if the contact book contains the passed `KNContact`.
     
     - Author: dragosrobertn
     - Parameters:
        - element: An `KNContact` object to be checked if it already exists in the contact book.
     
     - Returns: Return a boolean representing whether the contact book containts the passed `KNContact`.
     - Version: 1.0.0
     */
    public func contains(element: KNContact) -> Bool {
        return self.keysArray().contains(element.id)
    }

}
