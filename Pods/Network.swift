//
//  Network.swift
//  Pods
//
//  Created by Graham Nadel on 2/21/24.
//

import Foundation
import SwiftUI

enum Network: String, CaseIterable {
    case frenchPress
    case quebrada
    case homeWifi
    case hotspot
    
    var ip: String {
        switch self {
        case .frenchPress:
            return "192.168.208.183"
        case .homeWifi:
            return "192.168.0.24"
        case .quebrada:
            return "192.168.1.148"
        case .hotspot:
            return "10.21.8.101"
        }
    }
}
