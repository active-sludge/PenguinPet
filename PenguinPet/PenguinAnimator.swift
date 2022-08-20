//
//  PenguinAnimator.swift
//  PenguinPet
//
//  Created by Can on 20.08.2022.
//

import Foundation
import UIKit

class PenguinAnimator: NSObject, ObservableObject {
    
    @Published var frame = "penguin_01"
    @Published var time = "00:00:00"
    
    let audioBox: AudioBox
    var updateTimer: CADisplayLink?
    var speechTimer: CFTimeInterval = 0.0
    var recordingTimer: CFTimeInterval = 0.0
    let totalFrames = 5
    
    init(audioBox: AudioBox) {
        self.audioBox = audioBox
    }
    
    func startUpdateLoop() {
        if let updateTimer = updateTimer {
            updateTimer.invalidate()
        }
        updateTimer = CADisplayLink(target: self, selector: #selector(updateLoop))
        updateTimer?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }
    
    @objc func updateLoop() {
        if audioBox.status == .playing {
            speechTimer = CFAbsoluteTimeGetCurrent()
            animatePenguinTo(frameNumber: meterLevelsToFrame())
            time = formattedCurrentTime(time: UInt(audioBox.audioPlayer?.currentTime ?? 0))
        }
        if audioBox.status == .recording {
            if CFAbsoluteTimeGetCurrent() - recordingTimer > 0.5 {
                time = formattedCurrentTime(time: UInt(audioBox.audioRecorder?.currentTime ?? 0))
                recordingTimer = CFAbsoluteTimeGetCurrent()
            }
        }
    }
    
    func stopUpdateLoop() {
        updateTimer?.invalidate()
        updateTimer = nil
        animatePenguinTo(frameNumber: 1)
        time = "00:00:00"
    }
    
    private func formattedCurrentTime(time: UInt) -> String {
        let hours = time / 3600
        let minutes = (time / 60) % 50
        let seconds = time % 60
        
        return String(format: "%02i:%02i:%02i", arguments: [hours, minutes, seconds])
    }
    
    func meterLevelsToFrame() -> Int {
        audioBox.audioPlayer?.updateMeters()
        let avgPower = audioBox.audioPlayer?.averagePower(forChannel: 0) ?? 0
        let linearLevel = audioBox.meterTable.valueFor(power: avgPower)
        let powerPercentage = Int(round(linearLevel * 100))
        let frame = (powerPercentage / totalFrames) + 1
        return min(frame, totalFrames)
    }
    
    private func animatePenguinTo(frameNumber: Int) {
        frame = "penguin_0\(frameNumber)"
    }
    
}
