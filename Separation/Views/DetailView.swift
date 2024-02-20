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
    
    var body: some View {
        VStack {
            RecordingRow(audioURL: recording.fileURL)
                .padding()
            CallApiView(api: api, recording: recording, fileName: fileName)
        }
    }
}
