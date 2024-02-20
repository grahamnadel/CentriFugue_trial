//audioPlayer
import Foundation
import AVFoundation

class AudioPlayer: ObservableObject {
    var audioPlayer: AVAudioPlayer?
    let sampleRate = 44100.0
    
    @Published var audioDuration: Double?
    @Published var progress = 0.0
    @Published var isPlaying = false
    
    //Track the audio progress
//    var currentPosition: Double? {
//        guard audioPlayer?.duration ?? 0.0 > 0.0 else {
//            return nil
//        }
//        if let audioPlayer = audioPlayer {
//            let position = audioPlayer.currentTime / audioPlayer.duration
////            updateProgress(newValue: position)
//            print("Updating position")
//            return position
//        } else {
//            return nil
//        }
//    }
    
    func updateProgress(newValue currentPosition: Double) {
        progress = currentPosition
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
        print("audio: \(audioData)")
        
        let sr = 44100.0
        //        Convert from 2 channels to 1
        let flattenedAudioData = audioData.flatMap { $0 }
        
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
            return fileURL as URL
        } catch {
            print("Error writing audio file: \(error)")
            return nil
        }
    }
    
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            
            audioPlayer!.play()
            isPlaying = true
        } catch {
            print("Playback failed.")
        }
    }
    
    func stopPlayback() {
        audioPlayer!.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
    func floatToAVAudioPCMBuffer(_ twoChannelAudio: [[Float]]) -> AVAudioPCMBuffer? {
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
}


fileprivate enum SampleRate {
    case recording
    case separation
}
