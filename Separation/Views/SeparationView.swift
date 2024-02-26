//
//  SeparationView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/13/24.
//

import Foundation
import SwiftUI
import SwiftData

//TODO: Add scrollView
struct SeparationView: View {
    @ObservedObject var api: API
    @ObservedObject var audioPlayer: AudioPlayer
    
//    @Query var separations: [DataRecordingSeparation]
    @Environment(\.modelContext) var modelContext
    @State private var separations: [DataRecordingSeparation]?
    @State private var separationsHaveBeenCreated = true
    
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
                } else {
                    if separationsHaveBeenCreated {
                        ProgressView()
                    } else {
                        Text("You have no saved separations")
                    }
                }
            }
        }
        .onAppear {
            Task(priority: .background) {
                let cache = CachedDataHandler(modelContainer: modelContext.container)
                do {
                    let data = try await cache.loadAllData()
                    separationsHaveBeenCreated = true
                    separations = data
                    
                } catch {
                    print("Could not load data")
                    separationsHaveBeenCreated = false
                }
            }
        }
    }
}
