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
//    TODO: Could I combine keyboard active and isediting?
    @FocusState private var isKeyboardActive: Bool
    @State private var isEditing = false
    @State private var newName = ""
    @State var progress = 0.0
    @State var playerProgress = 0.0
    
    var instrumentsInRow: [String: [[Float]]] {
        let instruments = [
            "🎤": separation.vocals,
            "🐟": separation.bass,
            "🎸": separation.guitar,
            "🥁": separation.drums
        ]
        return instruments
    }
    
    init(_ separation: DataRecordingSeparation, _ audioPlayer: AudioPlayer) {
        self.separation = separation
        self.audioPlayer = audioPlayer
    }
    
    var body: some View {
        VStack {
            Button("Test") {
                if let audioPlayer = audioPlayer.audioPlayer {
                    if audioPlayer.isPlaying {
                        print("play")
                    } else {
                        print("no play hombre")
                    }
                } else {
                    print("NO audio")
                }
            }
            
            TextField(separation.name, text: $newName)
                .focused($isKeyboardActive)
                .textFieldStyle(RoundedBorderTextFieldStyle())
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
        
        //TODO: Issues with reDrawing all of the views!! change updates to willSet
//    instrumentsinRow: instrumentsInRow,
        InstrumentRowView( audioPlayer: audioPlayer) { selectedInstrument in
            //TODO: Convert this to an enum
            if let audioURL = audioPlayer.createAudioFile(from: instrumentsInRow[selectedInstrument] ?? separation.bass) {
                audioPlayer.startPlayback(audio: audioURL)
            }
        }
        
        playbackProgressView
        
        Group {
            if audioPlayer.isPlaying == false {
                Button(action: {
                        audioPlayer.play(atTime: nil)
                }) {
                    Image(systemName: "play.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
            } else {
                Button(action: {
                    self.audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 100)
            }
        }
        .opacity(audioPlayer.isAudioFileReady ? 1 : 0)
    }
    
    @ViewBuilder
    var playbackProgressView: some View {
        VStack {
            ProgressView(value: audioPlayer.progress)
                .overlay {
                    GeometryReader { geometry in
                        
                        Rectangle()
                            .fill(.clear)
                            .padding(.vertical)
                            .contentShape(Rectangle())
//                            .gesture(DragGesture()
//                                .onChanged{ drag in
//                                    if !audioPlayer.isPlaying {
//                                        playerProgress = audioPlayer.progress
//                                    }
//                                    
//                                    let offset = drag.translation.width / geometry.size.width
//                                    audioPlayer.progress = max(0, min(playerProgress + offset, 1))
//                                } .onEnded { _ in
//                                    
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
