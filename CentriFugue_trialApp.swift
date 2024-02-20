//
//  CentriFugueApp.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/9/24.
//
import SwiftData
import SwiftUI

@main
struct CentriFugue_trialApp: App {
    @StateObject var api = API()
    @StateObject var audioPlayer = AudioPlayer()
    @StateObject var audioRecorder = AudioRecorder()
    
    var body: some Scene {
        WindowGroup {
            MainView(audioPlayer: audioPlayer, audioRecorder: audioRecorder, api: api)
        }
        .modelContainer(for: DataRecordingSeparation.self)
    }
}
