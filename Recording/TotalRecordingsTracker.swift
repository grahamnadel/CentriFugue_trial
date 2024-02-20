//
//  TotalRecordingsTracker.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/16/24.
//

import Foundation

struct UserDefaultsKeys {
    static let totalRecordings = "TotalRecordings"
}

// Increase the recording count
func incrementRecordingsCount() {
    let defaults = UserDefaults.standard
    let currentTotal = defaults.integer(forKey: UserDefaultsKeys.totalRecordings)
    let newTotal = currentTotal + 1
    defaults.set(newTotal, forKey: UserDefaultsKeys.totalRecordings)
}

//Get the Recording count
func getRecordingsCount() -> Int {
    let defaults = UserDefaults.standard
    return defaults.integer(forKey: UserDefaultsKeys.totalRecordings)
}
