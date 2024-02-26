//
//  Data.swift
//
//
//  Created by Graham Nadel on 2/19/24.
//

import Foundation
import SwiftData

@Model
class DataRecordingSeparation {
    var name: String
    var category: String
    var drums: [[Float]]
    var guitar: [[Float]]
    var bass: [[Float]]
    var vocals: [[Float]]
    
    
    init(name: String, category: String, drums: [[Float]], guitar: [[Float]], bass: [[Float]], vocals: [[Float]]) {
        self.name = name
        self.category = category
        self.drums = drums
        self.guitar = guitar
        self.bass = bass
        self.vocals = vocals
    }
}
