//
//  SeparatedAudioView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/14/24.
//

import Foundation
import AVFoundation
import SwiftUI

struct SeparatedAudioView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    private let separation: DataRecordingSeparation
    @Environment(\.modelContext) var modelContext
    @State private var newName = ""
    @State private var isEditing = false
    @FocusState private var isKeyboardActive: Bool
    
    private var instrumentsInFirstRow: [(String, [[Float]])] {
        return [("🎤", separation.vocals), ("🐟", separation.bass)]
    }
    
    private var instrumentsInSecondRow: [(String, [[Float]])] {
        return [("🎸", separation.guitar), ("🥁", separation.drums)]
    }
    
    init(_ separation: DataRecordingSeparation, _ audioPlayer: AudioPlayer) {
        self.separation = separation
        self.audioPlayer = audioPlayer
    }
    
    var body: some View {
        VStack {
            //            Group {
            //Allow for the user to change the name of the file
            //                if !isEditing {
            //                    Text(separation.name)
            //                        .onTapGesture {
            //                            isEditing = true
            ////                            isKeyboardActive = true
            //                        }
            //                } else {
            TextField(separation.name, text: $newName)
                .focused($isKeyboardActive)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            //                }
        }
                .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button("Done") {
                            isKeyboardActive = false
                            updateItem(for: separation, with: newName)
                            isEditing = false
                        }
                    }
                }
        //            .font(.title)
        //            .foregroundColor(.white)
        //            .multilineTextAlignment(.center)
        //            .padding()
        
        InstrumentRowView(instrumentsinRow: instrumentsInFirstRow, audioPlayer: audioPlayer)
        
        InstrumentRowView(instrumentsinRow: instrumentsInSecondRow, audioPlayer: audioPlayer)
        
        AudioProgressView(audioPlayer: audioPlayer)
    }
    
    func updateItem(for item: DataRecordingSeparation, with newName: String) {
        // Edit the item data
        item.name = newName
        
        // Reset newName to an empty string
        self.newName = ""
    }
}
