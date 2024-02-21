//
//  RecordingList.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/14/24.
//

import Foundation
import SwiftUI

struct RecordingsList: View {
    @ObservedObject var api: API
    @ObservedObject var audioRecorder: AudioRecorder
    @ObservedObject var audioPlayer: AudioPlayer
    
    var body: some View {
        NavigationView {
            List {
                ForEach(audioRecorder.recordings, id: \.createdAt) { recording in
                    if let fileName = audioPlayer.getFileTitle(filePath: recording.fileURL) {
                    NavigationLink(
                        destination: DetailView(api, recording: recording, fileName: fileName),
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
    }
    
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(audioRecorder.recordings[index].fileURL)
        }
        audioRecorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}
