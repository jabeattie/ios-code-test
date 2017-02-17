//
//  Constants.swift
//  Farmdrop
//
//  Created by James Beattie on 16/02/2017.
//  Copyright © 2017 James Beattie. All rights reserved.
//

import Foundation

struct Fetching {
    static let Limit = 25
    static let Threshold = 5
}

struct FileNames {
    static let PlaceholderImage = "Placeholder"
    static let ProducersPlist = "Producers"
}

struct Time {
    static let DayInSeconds: Double = 84600
}

struct Errors {
    static let NoDest = (code: 1, domain: "No destination path")
    static let NoFile = (code: 2, domain: "No file at destination path")
    static let CNUnarc = (code: 3, domain: "Could not unarchive object")
    static let CNSave = (code: 4, domain: "Could not save producers")
}
