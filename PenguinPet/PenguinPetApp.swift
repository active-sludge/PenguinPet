//
//  SwiftUIView.swift
//  PenguinPet
//
//  Created by Can on 19.08.2022.
//

import SwiftUI
import AVFoundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
        } catch {
            print("AVAudioSession configuration error: \(error.localizedDescription)")
        }
        
        return true
    }
}

@main
struct PenguinPetApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
