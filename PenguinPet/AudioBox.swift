//
//  AudioBox.swift
//  PenguinPet
//
//  Created by Can on 19.08.2022.
//

import Foundation
import AVFoundation

class AudioBox: NSObject, ObservableObject {
    
    @Published var status: AudioStatus = .stopped
    
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
    
    func play() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: urlForMemo)
        } catch {
            print(error.localizedDescription)
        }
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.delegate = self
        
        if audioPlayer.duration > 0.0 {
            status = .playing
            audioPlayer.play()
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        status = .stopped
    }
    
    func record() {
        audioRecorder?.record()
        status = .recording
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        status = .stopped
    }
}

extension AudioBox: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        status = .stopped
    }
}

extension AudioBox: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        status = .stopped
    }
}
