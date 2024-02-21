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
    @State private var network: String
    
    init(_ api: API, recording: Recording, fileName: String) {
        self.api = api
        self.recording = recording
        self.fileName = fileName
        self._network = State(initialValue: Network.homeWifi.ip)
    }
    
    var body: some View {
        VStack {
            RecordingRow(audioURL: recording.fileURL)
                .padding()
            Picker("Network", selection: $network) {
                ForEach(Network.allCases, id: \.self) { network in
                    Text(network.rawValue).tag(network.ip)
                }
            }
            
            
            CallApiView(api: api, recording: recording, fileName: fileName)
        }
    }
}
