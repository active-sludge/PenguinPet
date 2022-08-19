//
//  AudioBox.swift
//  PenguinPet
//
//  Created by Can on 19.08.2022.
//

import Foundation
import AVFoundation

class AudioBox: NSObject, ObservableObject {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var urlForMemo: URL {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let filePath = "TempMemo.caf"
        return tempDir.appendingPathComponent(filePath)
    }
    
    func setupRecorder() {
        let recordSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: urlForMemo,
                                                settings: recordSettings)
            audioRecorder?.delegate = self
        } catch {
            print("Error creating audioRecorder")
        }
    }
    
    func record() {
        audioRecorder?.record()
    }
    
    func stopRecording() {
        audioRecorder?.stop()
    }
}

extension AudioBox: AVAudioRecorderDelegate {
    
}
