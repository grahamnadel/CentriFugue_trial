//audioPlayer
import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    let sampleRate = 44100.0
    
    @Published var boolTest = false
    func test() {
        boolTest.toggle()
    }
    
    @Published var audioDuration: Double?
    @Published var progress = 0.0
    @Published var isPlaying = false
    @Published var isAudioFileReady = false
    var separation: DataRecordingSeparation?
    
//    var currentPlayPauseState: PlayPauseState {
//        switch audioPlayer?.isPlaying {
//        case .true:
//            audioPlayer?.pause()
//        }
//    }
    
    func instrumentsInRow() -> [String: [[Float]]]? {
        if let separation = separation {
            return ["🎤": separation.vocals, "🐟": separation.bass, "🎸": separation.guitar, "🥁": separation.drums]
        } else {
            return nil
        }
    }
    
    func loadAudio(for audioUrl: URL) {
        print("loading")
        do {
            print("changing audioPlayer")
            self.audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioDuration = self.audioPlayer?.duration ?? nil
        } catch {
            print("failed to create AVAudioPlayer for separation.")
        }
    }
    
    func createAudioFile(from audioData: [[Float]]) -> URL? {
        print("called createAudioFile")
        let sr = 44100.0
        
        //        Convert from 2 channels to 1
        let flattenedAudioData = audioData[1]
        
        //        Create AVAudioFormat
        let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sr, channels: 1, interleaved: false)
        
        //        Unwrapt AVAudioFormat
        guard let format = audioFormat else {
            print("Error: Failed to create AVAudioFormat")
            return nil
        }
        
        //        Convert FLoat array to PCM buffer
        let pcmBuffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(flattenedAudioData.count))
        pcmBuffer?.frameLength = AVAudioFrameCount(flattenedAudioData.count)
        let audioBuffer = pcmBuffer?.floatChannelData?[0]
        for i in 0..<flattenedAudioData.count {
            audioBuffer?[Int(i)] = flattenedAudioData[i]
        }
        
        do {
            //        Write PCM buffer to temporary audio file
            let cachesDirectoryURL = try FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // Append a unique filename
            let fileURL = cachesDirectoryURL.appendingPathComponent("output.wav")
            
            let audioFile = try AVAudioFile(forWriting: fileURL as URL, settings: pcmBuffer!.format.settings)
            try audioFile.write(from: pcmBuffer!)
            isAudioFileReady = true
            return fileURL as URL
        } catch {
            print("Error writing audio file: \(error)")
            return nil
        }
    }
    
    func startPlayback(audio: URL) {
        print("called startPlayback")
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            
            play(atTime: nil)
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func play(atTime time: Double?) {
        print("called play")
        isPlaying = true
        if let time = time{
            audioPlayer?.play(atTime: time)
        } else {
            audioPlayer?.play()
        }
        trackPlayback()
    }
    
    func trackPlayback() {
        print("called trackPlayback")
        // Start a timer to update progress periodically
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            guard let audioPlayer = self.audioPlayer else {
                return
            }
            self.progress = min(audioPlayer.currentTime / audioPlayer.duration, 1.0)
            
            // Check if playback has finished
            if !audioPlayer.isPlaying {
                self.isPlaying = false
                timer.invalidate() // Stop the timer when playback finishes
            }
        }
        timer.fire() // Fire the timer immediately to update progress
    }
    
    func stopPlayback() {
        print("called stopPlayback")
        isPlaying = false
        audioPlayer!.stop()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("called audioPlayerDidFinishPlaying")
        if flag {
            isPlaying = false
        }
    }
    
    func floatToAVAudioPCMBuffer(_ twoChannelAudio: [[Float]]) -> AVAudioPCMBuffer? {
        print("called floatToAVAudioPCMBuffer")
        //TODO: Check if this flattening is still needed. If so, just instance into the 0 dimension of the 2D array
        let oneChannelAudio = twoChannelAudio.flatMap { $0 }
        
        guard let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false) else {
            print("Failed to create audioFormat")
            return nil
        }
        
        guard let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(oneChannelAudio.count)) else {
            return nil
        }
        
        // Access the float data of the buffer
        let bufferPointer = pcmBuffer.floatChannelData?[0]
        
        oneChannelAudio.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) in
            guard let srcPointer = pointer.bindMemory(to: Float.self).baseAddress else {
                return
            }
            bufferPointer?.initialize(from: srcPointer, count: oneChannelAudio.count)
        }
        
        return pcmBuffer
    }
    
    func floatsToData(_ twoChannelFloats: [[Float]]) -> Data {
        print("called floatsToData")
        let oneChannelFloats = twoChannelFloats.flatMap { $0 }
        var byteArray = [UInt8]()
        for floatValue in oneChannelFloats {
            var floatValueAsBytes = floatValue.bitPattern
            let bytes = withUnsafeBytes(of: &floatValueAsBytes) { Data($0) }
            byteArray.append(contentsOf: bytes)
        }
        return Data(byteArray)
    }
    
    func playAudioData(for audioData: Data) {
        print("called playAudioData")
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            if var audioPlayer = audioPlayer {
                audioPlayer = try AVAudioPlayer(data: audioData, fileTypeHint: "AVFileType.wav")
                audioPlayer.play()
            } else {
                print("Failed to unwrap audioPlayer")
            }
        } catch {
            print("Failed to add audioData to AVAudioPlayer: \(error)")
        }
    }
    
    func getFileTitle(filePath: URL) -> String? {
        let fileName = filePath.absoluteString
        
//        Find the range of the substring between "Documents/" and ".wav"
        if let rangeStart = fileName.range(of: "Documents/"),
            let rangeEnd = fileName.range(of: ".wav") {
            let startIndex = rangeStart.upperBound
            let endIndex = rangeEnd.lowerBound
            var targetString = String(fileName[startIndex..<endIndex])
            targetString = targetString.replacingOccurrences(of: "_", with: " ")
            return targetString
        } else {
            print("No file title found")
            return nil
        }
    }
    
//    func playPauseButtonTapped() {
//        switch currentPlayPauseState {
//        case .play:
//            audioPlayer?.pause()
//        case .pause:
//            Task {
//                audioPlayer?.play()
//                let progress = self.progress
//                
//            }
//        }
//        
//    }
}


fileprivate enum SampleRate {
    case recording
    case separation
}

//enum PlayPauseState {
//    case play
//    case pause
//    
//    var systemImage: String {
//        switch self {
//        case .play:
//            return "pause.fill"
//        case .pause:
//            return "play.fill"
//        }
//    }
//}
