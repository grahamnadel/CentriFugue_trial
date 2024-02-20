//
//  TabView.swift
//  Pods
//
//  Created by Graham Nadel on 2/13/24.
//

import Foundation
import SwiftUI

struct MainView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var api: API
    
    var body: some View {
        TabView {
            ContentView(audioPlayer: audioPlayer, audioRecorder: audioRecorder, api: api)
                .tabItem {
                    Label("Record", systemImage: "waveform.circle")
                }
            
            SeparationView(api: api, audioPlayer: audioPlayer)
                .tabItem {
                    Label("Separate", systemImage: "music.quarternote.3")
                }
        }
    }
}
