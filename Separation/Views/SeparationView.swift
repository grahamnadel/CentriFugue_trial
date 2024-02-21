//
//  SeparationView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/13/24.
//

import Foundation
import SwiftUI
import SwiftData

struct SeparationView: View {
    @ObservedObject var api: API
    @ObservedObject var audioPlayer: AudioPlayer
    
    @Query var separations: [DataRecordingSeparation]
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            VStack {
                List(separations) { separation in
                    NavigationLink(separation.name, destination: SeparatedAudioView(separation, audioPlayer))
                        .swipeActions {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                modelContext.delete(separation)
                            }
                        }
                }
            }
        }
    }
}
