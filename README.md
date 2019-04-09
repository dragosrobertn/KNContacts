# KNContacts 
![Cocoapods](https://img.shields.io/cocoapods/v/KNContacts.svg) [![Build Status](https://travis-ci.org/dragosrobertn/KNContacts.svg?branch=master)](https://travis-ci.org/dragosrobertn/KNContacts) [![codecov](https://codecov.io/gh/dragosrobertn/KNContacts/branch/master/graph/badge.svg)](https://codecov.io/gh/dragosrobertn/KNContacts)

KNContacts is wrapper for CNContacts for easier access to information like current age and age at next birthday, full contact name, creating contact books (groups), ordering them and creating contact schedules.

### More information

KNContacts framework features a couple of classes, structs and enums to facilitate access to contacts, contact books and schedule of contacts.

| Type            | Name                                    | Description  |
| ------------- | -------------------------------- | -------------- |
| struct          | KNContact                            | Wrapper struct for CNContact, provides access to helper methods and original contact details. |
| class           | KNContactBook                   | Collection of KNContacts with methods for adding, removing, sorting and retrieving specific or random elements |
| struct          | KNContactBookOrdering     | Helper ordering methods to sort contacts in KNContactBook  |
| struct          | KNContactsSchedule           | Dictionary wrapper for creating contact schedule for using custom time formats for scheduling and retrieving at a particular time  |
| struct          | KNDatesUtils                        | Date formatting helper methods |
| enum          | KNTimeFormat                     | Enum with pre-defined time formats |

It also provides some extensions to Array type, Dates and Int.

## Usage

*Sample initialisation and usage*

### `KNContact` and `KNContactBook`
KNContact is a wrapper structure and you can initialise a new obejct by passing in a CNContact or CNMutableContact object. KNContactBook is a collection of KNContact objects which can be sorted and random elements extracted.

```swift
import Contacts
import KNContacts

var allContacts = KNContactBook(id: "allContacts")

// Retrieve or create your CNContact list from a store - KNContacts does *not* handle authorisation for you.
// Make sure you have all necessary key descriptors.

var keys = [CNContactGivenNameKey, CNContactMiddleNameKey, CNContactFamilyNameKey,
            CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactPhoneNumbersKey,
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName)] as! [CNKeyDescriptor]

let requestForContacts = CNContactFetchRequest(keysToFetch: keys)

do {
    try CNContactStore().enumerateContacts(with: requestForContacts) { (cnContact, _) in
        let knContact = KNContact(for: cnContact)
        allContacts.add(knContact)
    }
} catch let error {
    // Handle error somehow!
    print(error)
}

// And then perform actions on KNContactBook
let randomContacts = allContacts.randomElements(number: 1)
let randomElements = allContacts.randomElements(number: 3, except: randomContacts)

randomElements.forEach({ (contact) in 
    print(contact.fullName(format: .fullName))
    if (contact.isBirthdayToday()) {
        print("It's their birthday today!")
    } else if (contact.isBirthdayComing(in: 7)) {
        print("Birthday coming up in the next week!")
    } else {
        print("Birthday on \(contact.formattedBirthday())")
    }
})
```
### `KNContactsSchedule`,  `KNContactBookOrdering`, `KNDatesUtils`

`KNContactBook` can also return ordered array of elements. Two options are provided in `KNContactBookOrdering`
But the `toArray(orderedBy:)` method can take any sorting function.
`KNDatesUtils` provides easy access to string date formatters.

```swift

let order = KNContactBookOrdering().thisYearsBirthday
let contactsSortedByBirthday = allContacts.toArray(orderedBy: order)

// And finally schedules can be created for easier retrieval at a later date.
var thisWeeksBirthdaySchedule = KNContactsSchedule(name: "birthdaysThisYear")

for dayCount in 1...7 {
    let birthdayList = contactsSortedByBirthday.filter({ $0.isBirthdayComing(in: dayCount) }).map({ $0.id })
    let date = Calendar.current.date(byAdding: .day, value: dayCount, to: Date())!
    let dateString = KNDatesUtils().formatter(with: .fullDate).string(from: date)
    thisWeeksBirthdaySchedule.add(list: birthdayList, fromString: dateString)
}

// And retrieve schedule by date
let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
let schedule = thisWeeksBirthdaySchedule.getSchedule(for: tomorrow)

```

### Still left to do
- [ ] Documentation
- [ ] Better error handling

### Requirements
- Swift 4.2

### Usage
KNContacts is currently available using CocoaPods. Just add this snippet into your podfile to use the latest version.

```ruby
pod 'KNContacts'
```

### Applications using KNContacts
- [KINN - Contacts Manager](https://itunes.apple.com/app/kinn/id1343398089)

If your app uses KNContacts, feel free to submit a Pull Request.

### Contributing
Pull requests are welcome, all changes should be accompanied by tests and a passing build. 

Issues or features requests are welcome, feel free to create implementations yourself. The development of this framework is done using trunk based development strategy so please create your pull requests against the master branch and ensure the build is passing.

This library is MIT Licensed.
