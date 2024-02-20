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
    @FocusState private var isKeyboardActive: Bool
    @State private var newName = ""
    @State private var isEditing = false
    @State var progress = 0.0
    @State var scrubStartProgress = 0.0
    var test = 0.5
    
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
        
        HStack {
            playbackProgressView
            if audioPlayer.isPlaying == false {
                Button(action: {
//                    self.audioPlayer.startPlayback(audio: self.audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
    }
    
    @ViewBuilder
    var playbackProgressView: some View {
        VStack {
            ProgressView(value: audioPlayer.progress)
                .overlay {
                    GeometryReader { geometry in
                        let line = Rectangle()
                            .fill(.red)
                            .frame(width: 1, height: 20)
                        
                        Rectangle()
                            .fill(.clear)
                            .padding(.vertical)
                            .contentShape(Rectangle())
//                            .gesture(DragGesture()
//                                .onChanged{ drag in
//                                    if !audioPlayer.isPlaying {
//                                        scrubStartProgress = audioPlayer.progress
//                                    }
//                                    
//                                    let offset = drag.translation.width / geometry.size.width
//                                    audioPlayer.progress = max(0, min(scrubStartProgress + offset, 1))
//                                } .onEnded { _ in
//                                    //audioPlayer.isScrubbing = false
//                                    scrubStartProgress = 0
////                                    }
//                                })
                    }
                }
        }
    }
    
    func updateItem(for item: DataRecordingSeparation, with newName: String) {
        // Edit the item data
        item.name = newName
        
        // Reset newName to an empty string
        self.newName = ""
    }
}
