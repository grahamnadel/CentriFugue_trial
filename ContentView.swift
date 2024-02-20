
//  ContentView.swift
//  Test
//
//  Created by Graham Nadel on 2/8/24.
//

import SwiftUI
import SwiftData
import Alamofire
import AVFoundation

struct ContentView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var api: API
    
    var body: some View {
        VStack {
            RecordingsList(api: api, audioRecorder: audioRecorder, audioPlayer: audioPlayer)
            
            RecordView(audioRecorder: audioRecorder)
        }
        .padding()
    }
}

//#Preview {
//    ContentView()
//}
