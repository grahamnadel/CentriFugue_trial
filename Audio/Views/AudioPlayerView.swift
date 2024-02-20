//
//  AudioPlayerView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/14/24.
//

import Foundation
import SwiftUI

struct AudioPlayerView: View {
    @ObservedObject var audioPlayer = AudioPlayer()
    let audioData: [[Float]]
    let audioName: String
    
    var body: some View {
        HStack {
            if audioPlayer.isPlaying == false {
                Button(action: {
                    
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
