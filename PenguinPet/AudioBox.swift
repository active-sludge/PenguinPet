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
    let meterTable = MeterTable(tableSize: 100)
    var audioAVEngine = AVAudioEngine()
    var enginePlayer = AVAudioPlayerNode()
    var pitchEffect = AVAudioUnitTimePitch()
    var reverbEffect = AVAudioUnitReverb()
    var engineAudioFile: AVAudioFile!
    
    var urlForMemo: URL {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let filePath = "TempMemo.caf"
        return tempDir.appendingPathComponent(filePath)
    }
    
    override init() {
        super.init()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(handleInteruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupAudioEngine() {
        let format = audioAVEngine.inputNode.inputFormat(forBus: 0)
        audioAVEngine.attach(enginePlayer)
        audioAVEngine.attach(pitchEffect)
        audioAVEngine.attach(reverbEffect)
        audioAVEngine.connect(enginePlayer, to: pitchEffect, format: format)
        audioAVEngine.connect(pitchEffect, to: reverbEffect, format: format)
        audioAVEngine.connect(reverbEffect, to: audioAVEngine.outputNode, format: format)
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.largeChamber)
        pitchEffect.pitch = 1.0
        reverbEffect.wetDryMix = 50
        
        do {
            try audioAVEngine.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func handleRouteChange(notification: Notification) {
        if let info = notification.userInfo,
           let rawValue = info[AVAudioSessionRouteChangeReasonKey] as? UInt {
            let reason = AVAudioSession.RouteChangeReason(rawValue: rawValue)
            if reason == .oldDeviceUnavailable {
                guard let previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription,
                      let previousOutput = previousRoute.outputs.first else {
                    return
                }
                if previousOutput.portType == .headphones {
                    if status == .playing {
                        stopPlayback()
                    } else if status == .recording {
                        stopRecording()
                    }
                }
            }
        }
    }
    
    @objc func handleInteruption(notification: Notification) {
        if let info = notification.userInfo,
           let rawValue = info[AVAudioSessionInterruptionTypeKey] as? UInt {
            let type = AVAudioSession.InterruptionType(rawValue: rawValue)
            if type == .began {
                if status == .playing {
                    stopPlayback()
                } else if status == .recording {
                    stopRecording()
                }
            } else {
                if let rawValue = info[AVAudioSessionInterruptionOptionKey] as? UInt {
                    let options = AVAudioSession.InterruptionOptions(rawValue: rawValue)
                    if options == .shouldResume {
                        // restart audio or restart recording
                    }
                }
            }
        }
    }
    
    
    func setupRecorder() {
        let recordSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            audioRecorder = try AVAudioRecorder(url: urlForMemo, settings: recordSettings)
            audioRecorder?.delegate = self
        } catch {
            print("Error creating audioRecorder")
        }
    }
    
    func record() {
        audioRecorder?.record()
        status = .recording
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        status = .stopped
    }
    
    func play() {
        do {
            engineAudioFile = try AVAudioFile(forReading: urlForMemo)
        } catch {
            print(error.localizedDescription)
        }
        guard let player = try? AVAudioPlayer(contentsOf: urlForMemo) else {
            audioPlayer = nil
            engineAudioFile = nil
            print("error playing audio")
            return
        }
        player.delegate = self
        
        if player.duration > 0.0 {
            player.volume = 0
            player.isMeteringEnabled = true
            player.prepareToPlay()
        }
        audioPlayer = player
        enginePlayer.scheduleFile(engineAudioFile, at: nil, completionHandler: nil)
        enginePlayer.play()
        audioPlayer?.play()
        status = .playing
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        enginePlayer.stop()
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
