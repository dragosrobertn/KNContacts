# KNContacts ![Cocoapods](https://img.shields.io/cocoapods/v/KNContacts.svg) [![Build Status](https://travis-ci.org/dragosrobertn/KNContacts.svg?branch=master)](https://travis-ci.org/dragosrobertn/KNContacts) [![codecov](https://codecov.io/gh/dragosrobertn/KNContacts/branch/master/graph/badge.svg)](https://codecov.io/gh/dragosrobertn/KNContacts)

KNContacts is wrapper for CNContacts for easier access to information like current age and age at next birthday, full contact name, creating contact books (groups), ordering them and creating contact schedules.

### More information

KNContacts framework features a couple of classes, structs and enums to facilitate access to contacts, contact books and schedule of contacts.

| Type            | Name           | Description  |
| ------------- |:--------------:| --------------:|
| struct          | KNContact   |  Wrapper struct for CNContact, provides access to helper methods and original contact details. |
| class           | KNContactBook      |  Collection of KNContacts with methods for adding, removing, sorting and retrieving specific or random elements |
| struct          | KNContactBookOrdering     |   Helper ordering methods to sort contacts in KNContactBook  |
| struct          | KNContactsSchedule      |   Dictionary wrapper for creating contact schedule for using custom time formats for scheduling and retrieving at a particular time  |
| struct          | KNDatesUtils     | Date formatting helper methods |
| enum          | KNTimeFormat      | Enum with pre-defined time formats |

It also provides some extensions to Array type, Dates and Int.

### More to do
- Documentation
- Better error handling

### Requirements
- Swift 4.2

### Usage
```
    pod 'KNContacts'
```

### Applications using KNContacts
- KINN - Contacts Manager

### Contributing
Pull requests are welcome, all changes should be accompanied by tests and a passing build. 

Issues or features requests are welcome, feel free to create implementations yourself. The development of this framework is done using trunk based development strategy so please create your pull requests against the master branch and ensure the build is passing.

This framework is MIT Licensed.
