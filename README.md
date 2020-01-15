# KNContacts 
[![Cocoapods](https://img.shields.io/cocoapods/v/KNContacts.svg)](https://cocoapods.org/pods/KNContacts) [![Build Status](https://travis-ci.org/dragosrobertn/KNContacts.svg?branch=master)](https://travis-ci.org/dragosrobertn/KNContacts) [![codecov](https://codecov.io/gh/dragosrobertn/KNContacts/branch/master/graph/badge.svg)](https://codecov.io/gh/dragosrobertn/KNContacts) ![contributions](https://img.shields.io/badge/contributions-welcome-informational.svg)

KNContacts is wrapper for CNContacts for easier access to information like current age and age at next birthday, full contact name, creating contact books (groups), ordering them and creating contact schedules.

### More information

KNContacts framework features a couple of classes, structs and enums to facilitate access to contacts, contact books and schedule of contacts.

| Type            | Name                                    | Description  |
| ------------- | -------------------------------- | -------------- |
| struct          | [KNContact](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContact.swift)                           | Wrapper struct for CNContact, provides access to helper methods and original contact details. |
| class           | [KNContactBook](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContactBook.swift)                   | Collection of KNContacts with methods for adding, removing, sorting and retrieving specific or random elements |
| struct          | [KNContactBookOrdering](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContactBookOrdering.swift)   | Helper ordering methods to sort contacts in KNContactBook  |
| struct          | [KNContactsSchedule](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContactsSchedule.swift)         | Dictionary wrapper for creating contact schedule for using custom time formats for scheduling and retrieving at a particular time  |
| struct          | [KNDatesUtils](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNDatesUtils.swift)                     | Date formatting helper methods |
| enum            | [KNTimeFormat](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNTimeFormat.swift)                     | Enum with pre-defined time formats |

## Documentation
[You can check the full documentation here.](https://dragosrobertn.github.io/KNContacts/)

## Usage

*Sample initialisation and usage*

### `KNContact` and `KNContactBook`
[KNContact](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContact.swift) is a wrapper structure and you can initialise a new obejct by passing in a CNContact or CNMutableContact object. [KNContactBook](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContactBook.swift) is a collection of KNContact objects which can be sorted and random elements extracted.

```swift
import Contacts
import KNContacts

var contactBook = KNContactBook(id: "allContacts")

// Retrieve or create your CNContact list from a store - KNContacts does *not* handle authorisation for you.
// Make sure you have all necessary key descriptors.

var keys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey,
            CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactPhoneNumbersKey,
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName)] as! [CNKeyDescriptor]

let requestForContacts = CNContactFetchRequest(keysToFetch: keys)

do {
    try CNContactStore().enumerateContacts(with: requestForContacts) { (cnContact, _) in
        let knContact = KNContact(cnContact)
        contactBook.add(knContact)
    }
} catch let error {
    // Handle error somehow!
    print(error)
}

// And then perform actions on KNContactBook
let randomContacts = contactBook.randomElements(number: 1)
let randomElements = contactBook.randomElements(number: 3, except: randomContacts)

randomElements.forEach({ (contact) in 
    print(contact.fullName(format: .fullName))
    if (contact.isBirthdayToday()) {
        print("It's their birthday today!")
    } else if (contact.isBirthdayComing(in: 7)) {
        print("Birthday coming up in the next week!")
    } else {
        print("Birthday on \(contact.formatBirthday())")
    }
})
```
### `KNContactsSchedule`,  `KNContactBookOrdering`, `KNDatesUtils`

[KNContact](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContact.swift) can also return ordered array of elements. Two options are provided in [KNContactBookOrdering](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNContactBookOrdering.swift)
But the `toArray(orderedBy:)` method can take any sorting function.
[KNDatesUtils](https://github.com/dragosrobertn/KNContacts/blob/master/KNContacts/KNDatesUtils.swift) provides easy access to string date formatters.

```swift
let order = KNContactBookOrdering.thisYearsBirthday
let contactsSortedByBirthday = contactBook.contacts.sorted(by: order)

// And finally schedules can be created for easier retrieval at a later date.
var thisWeeksBirthdaySchedule = KNContactsSchedule(name: "birthdaysThisYear")

for numberOfDays in 1...7 {
    let birthdayList = contactsSortedByBirthday.filter({ $0.isBirthdayComing(in: numberOfDays) }).map({ $0.id })
    let date = Calendar.current.date(byAdding: .day, value: numberOfDays, to: Date())!
    let dateString = KNDatesUtils.formatter(with: .fullDate).string(from: date)
    thisWeeksBirthdaySchedule.add(list: birthdayList, to: dateString)
}

// And retrieve schedule by date
let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
let schedule = thisWeeksBirthdaySchedule.getSchedule(for: tomorrow)
```

### Requirements
| KNContacts version |  Swift Version |
|--------------------|----------------|
| from `v1.2.0`      | Swift 5.0      |
| up to `v1.1.1`     | Swift 4.2      |

### Usage
KNContacts is currently available using CocoaPods. Just add this snippet into your podfile to use the latest version.

```ruby
pod 'KNContacts'
```

or specify the desired version.
```ruby
pod 'KNContacts', '~> 1.0.0'
```

### Applications using KNContacts
- [KINN - Contacts Manager](https://itunes.apple.com/app/kinn/id1343398089)

If your app uses KNContacts, feel free to submit a Pull Request.

### Contributing
Pull requests are welcome, all changes should be accompanied by tests and a passing build. 

Issues or features requests are welcome, feel free to create implementations yourself. The development of this framework is done using trunk based development strategy so please create your pull requests against the master branch and ensure the build is passing.

This library is MIT Licensed.
