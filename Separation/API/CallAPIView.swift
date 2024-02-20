//
//  CallApiView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/14/24.
//

import Foundation
import SwiftUI

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
                api.callAPI(for: recording.fileURL) { success in
                    if success {
                        print("Success")
                        if let separatedAudio = api.separatedAudio {
                            //save to swift Data
                            let data = DataRecordingSeparation(name: fileName, category: "Default", drums: separatedAudio.drums, guitar: separatedAudio.other, bass: separatedAudio.bass, vocals: separatedAudio.vocals)
                            print("Saving")
                            modelContext.insert(data)
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
