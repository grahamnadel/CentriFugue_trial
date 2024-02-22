//
//  CallApiView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/14/24.
//

import Foundation
import SwiftUI
import SwiftData

@ModelActor
actor CachedDataHandler {
    func persist(item: DataRecordingSeparation) {
        modelContext.insert(item)
        try? modelContext.save()
    }
    
    func loadAllData() throws -> [DataRecordingSeparation] {
        let predicate = #Predicate<DataRecordingSeparation> { data in 1==1 }
        let sort = SortDescriptor<DataRecordingSeparation>(\DataRecordingSeparation.name)
        let descriptor = FetchDescriptor(predicate: predicate, sortBy: [sort])
        
        let result = try modelContext.fetch(descriptor)
        return result
    }
}

struct CallApiView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var api: API
    let recording: Recording
    let fileName: String
    
    var body: some View {
        ZStack {
            Capsule()
                .foregroundColor(.white)
                .frame(width: 200, height: 150)
            Button {
                //TODO: Encapsulate
                api.callAPI(for: recording.fileURL) { success in
                    if success {
                        if let separatedAudio = api.separatedAudio {
                            //save to swift Data
                            let data = DataRecordingSeparation(name: fileName, category: "Default", drums: separatedAudio.drums, guitar: separatedAudio.other, bass: separatedAudio.bass, vocals: separatedAudio.vocals)
                            Task(priority: .background) {
                                let cache = CachedDataHandler(modelContainer: modelContext.container)
                                await cache.persist(item: data)
//                                modelContext.insert(data)
                            }
                        } else {
                            print("Failed to add separations to swift data")
                        }
                    } else {
                        print("callAPI failed")
                    }
                }
            } label: {
                Label("Separate", systemImage: "music.quarternote.3")
                    .font(.title)
            }
            .tint(.red)
            .disabled(api.isSeparating)
        }
    }
}
