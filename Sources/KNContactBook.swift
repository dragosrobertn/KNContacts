//
//  ContactBook.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 01/02/2018.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//
#if canImport(UIKit)
import Foundation

/**
KNContactBook class is a collection of `KNContact` objects to help with
contact grouping, sorting and selecting random elements.
    
- Author: dragosrobertn
- Version: 1.1.0
**/
public class KNContactBook {
    
    /// The contact book identifier or name.
    public var id: String
    private var entries: [String: KNContact] = [:]
    
    /// An read-only list of all identifiers used to retrieve the contacts by in the contact book.
    /// These can be custom, but by default they use the `KNContacts.id` value.
    public var identifiers: [String] { get { return Array(self.entries.keys) } }
    
    /// A  read-only array list of all contacts in the contact book.
    public var contacts: [KNContact] { get { return Array(self.entries.values) } }
    
    /// A read-only array list of all contact identifiers stored in the contact book.
    /// It represents the identifiers of KNContacts stored in the contact book, as opposed to how the contact book identifies the entries.
    public var contactIdentifiers: [String] { get { return self.contacts.map { $0.id } } }
    
    /// The number of entries in the contact book
    public var count: Int { get { return self.entries.count } }
    
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
     Retrieves a `KNContact` from the contact book by using the passed key identifier.
     
     - Author: dragosrobertn
     - Parameters:
        - by: A string representing an identifier to retrieve a contact from the contact book.
     
     - Returns: If found, it returns the `KNContact` object from the contact book. Otherwise nil.
     - Version: 1.1.0
     
     - Warning:
     This method force unwraps the value and it can return nil if asked to return an element that doesn't exist.
     If unsure if the KNContact exists in the contact book, use `KNContactBook().getOptional(forKey:)` instead.
     */
    public func getContact(by contactID: String) -> KNContact! {
        return self.entries[contactID]
    }
    
    /**
     Retrieves multiple `KNContact` objects from the contact book by using the passed array of KNContacts.
     
     - Author: dragosrobertn
     - Parameters:
        - by: An array of `KNContact` to retrieve updated information for a contact from the contact book.
     
     - Returns: If found, it returns an array of `KNContact` objects from the contact book.
     - Version: 1.1.0
     */
    public func getContacts(by contactsArray: [KNContact]) -> [KNContact] {
        return contactsArray.compactMap { self.getContact(by: $0.id) }
    }
    
    /**
     Retrieves multiple `KNContact` objects from the contact book by using the passed array of KNContacts.
     
     - Author: dragosrobertn
     - Parameters:
        - by: An array of strings to retrieve updated information for multiple contacts from the contact book.
     
     - Returns: If found, it returns an array of `KNContact` objects from the contact book.
     - Version: 1.1.0
     */
    public func getContacts(by contactIds: [String]) -> [KNContact] {
        return contactIds.compactMap { self.getContact(by: $0) }
    }
    
    /**
    Appends a `KNContact` to the contact book, identified by the contacts identifier.
     
     - Author: dragosrobertn
     - Parameters:
        - contact: A `KNContact` object to be added to the contact book.
     
     - Version: 1.0.0
     */
    public func add(_ contact: KNContact) {
        self.add(contact, id: contact.id)
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
        self.remove(contact.id)
    }
    
    /**
     Removes multiple `KNContact`objects from the contact book if it can find them in the contact book.
     
     - Author: dragosrobertn
     - Parameters:
        - contacts: An array of `KNContact` objects to attempt removal from the contact book.
     
     - Version: 1.0.0
     */
    public func remove(_ contacts: [KNContact]) {
        contacts.forEach({ contact in self.remove(contact.id) })
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
        var differenceList = self.contacts.difference(from: except)
        
        guard number < differenceList.count else { return differenceList }
        
        var arrayOfRandomContacts: [KNContact] = [KNContact]()
        
        for _ in 1...number {
            guard let randomElement = differenceList.randomItem() else { break }
            arrayOfRandomContacts.append(randomElement)
            differenceList = differenceList.difference(from: [randomElement])
        }
        
        return arrayOfRandomContacts
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
        return self.contacts.contains(element)
    }
    
    /**
     Resets the contact book by invalidating the stored contact entries.
     
     - Author: dragosrobertn
     - Version: 1.0.0
     */
    public func reset() {
        self.entries = [:]
    }

}

#endif
