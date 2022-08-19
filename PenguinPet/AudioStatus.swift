//
//  AudioStatus.swift
//  PenguinPet
//
//  Created by Can on 19.08.2022.
//

import Foundation

enum AudioStatus: Int, CustomStringConvertible {
    case stopped, playing, recording
    
    var audioName: String {
        let audioNames = ["Audio:Stopped",
                          "Audio:Playing",
                          "Audio:Recording"]
        return audioNames[rawValue]
    }
    
    var description: String {
        return audioName
    }
}
