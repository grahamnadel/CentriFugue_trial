//SeparatedAudio

import Foundation

struct SeparatedAudio: Codable {
    var songName: String
    let drums: [[Float]]
    let bass: [[Float]]
    let other: [[Float]]
    let vocals: [[Float]]
}

enum Instruments: String, CaseIterable, Identifiable {
    case drums
    case bass
    case guitar
    case vocals
    
    var id: String { self.rawValue }
    
//    var url: URL? {
//        switch self {
//
//        }
//    }
}


