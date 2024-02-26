//
//  DetailView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/16/24.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @ObservedObject var api: API
    let recording: Recording
    let fileName: String
//    @State private var network: String
    var showRecordView: (Bool) -> Void // Control whether or not to show the RecordView
    
    init(_ api: API, recording: Recording, fileName: String, showRecordView: @escaping (Bool) -> Void) {
        self.api = api
        self.recording = recording
        self.fileName = fileName
//        self._network = State(initialValue: Network.homeWifi.ip)
        self.showRecordView = showRecordView
    }
    
    var body: some View {
        VStack {
            RecordingRow(audioURL: recording.fileURL)
                .padding()
            Text("DetailView")
//            Picker("Network", selection: $network) {
//                ForEach(Network.allCases, id: \.self) { network in
//                    Text(network.rawValue).tag(network.ip)
//                }
//            }
            
            
            CallApiView(api: api, recording: recording, fileName: fileName)
        }
        .onAppear {
            showRecordView(false)
        }
        .onDisappear {
            showRecordView(true)
        }
    }
}
