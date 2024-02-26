//
//  InstrumentRowView.swift
//  Pods
//
//  Created by Graham Nadel on 2/20/24.
//

import Foundation
import SwiftUI

struct InstrumentRowView: View {
//    let instrumentsinRow: [(String, [[Float]])]
    @ObservedObject var audioPlayer: AudioPlayer
    var didSelectInstrument: ((String) -> Void)?
    var instrumentsInRow = ["🎤", "🐟", "🎸", "🥁"]
    
    var body: some View {
        HStack {
            ForEach(instrumentsInRow, id: \.self) { instrument in
                CardView(instrument: instrument)
                    .disabled(audioPlayer.isPlaying)
                    .onTapGesture {
//                        if let audioURL = audioPlayer.createAudioFile(from: audio) {
//                            audioPlayer.startPlayback(audio: audioURL)
//                        }
                        didSelectInstrument?(instrument)
                    }
            }
        }
    }
}
