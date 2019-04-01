//
//  KNTimeFormat.swift
//  KNContacts
//
//  Created by Dragos-Robert Neagu on 01/04/2019.
//  Copyright © 2019 Dragos-Robert Neagu. All rights reserved.
//

public enum KNTimeFormat: String, Codable {
    case hourAndMinutes = "HH:mm"
    case dayAndMonth = "d MMM"
    case fullDate = "yyyy-MM-dd"
    case timeStamp = "yyyy-MM-dd HH:mm"
    case dayAndFullMonth = "d MMMM"
    case fullMonth = "MMMM"
}
