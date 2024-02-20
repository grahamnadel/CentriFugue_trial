
//  Recorder.swift
//  Test
//
//  Created by Graham Nadel on 2/9/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class AudioRecorder: NSObject, ObservableObject {
    
    override init() {
        super.init()
        fetchRecording()
    }
    
    private let sampleRate = 44100
    let objectWillChange = PassthroughSubject<AudioRecorder, Never>()
    
    var audioRecorder: AVAudioRecorder!
    
    var recordings = [Recording]()
    
    var recording = false {
        didSet {
            objectWillChange.send(self)
        }
    }
    
    func startRecording() {
        incrementRecordingsCount()
        let recordingCount = getRecordingsCount()
        let recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }
        
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-YY 'at' HH:mm:ss"
//        let dateString = dateFormatter.string(from: Date())
        
        let audioFilename = documentPath.appendingPathComponent("Recording_\(recordingCount).wav")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: sampleRate,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            
            recording = true
        } catch {
            print("Could not start recording")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        recording = false
        
        fetchRecording()
    }
    
    func fetchRecording() {
        recordings.removeAll()
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        for audio in directoryContents {
            let date = getFileDate(for: audio)
            let recording = Recording(fileName: "",fileURL: audio, createdAt: date)
            recordings.append(recording)
        }
        
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedAscending})
        
        objectWillChange.send(self)
    }
    
    func deleteRecording(urlsToDelete: [URL]) {
        
        for url in urlsToDelete {
            print(url)
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        
        fetchRecording()
    }
    
    func getFileDate(for file: URL) -> Date {
        if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
           let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            return creationDate
        } else {
            return Date()
        }
    }
    
    func editRecordingPath(forFilePath originalFilePath: URL, newName: String) -> URL? {
        let fileManager = FileManager.default
        let newURL = originalFilePath.deletingLastPathComponent().appendingPathComponent(newName + ".wav")
        
        do {
            try fileManager.moveItem(at: originalFilePath, to: newURL)
            return newURL
        } catch {
            print("Error editing recording path: \(error.localizedDescription)")
            return nil
        }
    }
}

struct Recording: Identifiable {
    let id = UUID()
    
    var fileName = ""
    let fileURL: URL
    let createdAt: Date
}

