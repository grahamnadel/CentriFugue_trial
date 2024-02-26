
//  ContentView.swift
//  Test
//
//  Created by Graham Nadel on 2/8/24.
//

import SwiftUI
import SwiftData
import Alamofire
import AVFoundation

//TODO: Add scrollView
struct ContentView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var api: API
    @State private var showRecordView = true
    @State private var recording = false
    
    var body: some View {
        VStack {
            recordList
            
            if showRecordView {
                recordView
            }
        }
        .padding()
    }
    
    private var recordView: some View {
        VStack {
            Button(action : {
                if audioRecorder.recording {
                    audioRecorder.stopRecording()
                    recording = false
                } else {
                    audioRecorder.startRecording()
                    recording = true
                }
            }) {
                RecordButtonView(audioRecorder: audioRecorder)
            }
        }
    }
    
    private var recordList: some View {
        NavigationView {
            List {
                ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                    if let fileName = audioPlayer.getFileTitle(filePath: recording.fileURL) {
                        NavigationLink(
                            destination: DetailView(api, recording: recording, fileName: fileName) { bool in
                                showRecordView = bool
                            },
                            label: {
                                Text(fileName)
                            }
                        )
                    } else {
                        Text("Unable to retrieve file name for \(recording.fileName)")
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .onAppear {
            showRecordView = true
            print("appeared")
        }
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}
