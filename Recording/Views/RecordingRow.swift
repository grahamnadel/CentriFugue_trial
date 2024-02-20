//
//  RecordingRow.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/14/24.
//

import Foundation
import SwiftUI

struct RecordingRow: View {
    var audioURL: URL
    @ObservedObject var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            if let fileName = audioPlayer.getFileTitle(filePath: audioURL) {
                Text(fileName)
            } else {
                Text(audioURL.lastPathComponent)
            }
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    self.audioPlayer.startPlayback(audio: self.audioURL)
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
}
