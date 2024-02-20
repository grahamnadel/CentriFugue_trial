import SwiftUI
import AVFoundation

struct RecordView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    @State private var recording = false
    
    var body: some View {
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
}
