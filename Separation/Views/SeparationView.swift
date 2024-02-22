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
    
//    @Query var separations: [DataRecordingSeparation]
    @Environment(\.modelContext) var modelContext
    @State private var separations: [DataRecordingSeparation]?
    
    var body: some View {
        NavigationView {
            VStack {
                if let separations = separations {
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
        .onAppear {
            Task(priority: .background) {
                let cache = CachedDataHandler(modelContainer: modelContext.container)
                do {
                    let data = try await cache.loadAllData()
                    separations = data
                } catch {
                    print("Could not load data")
                }
            }
        }
    }
}
