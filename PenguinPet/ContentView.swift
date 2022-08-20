//
//  SwiftUIView.swift
//  PenguinPet
//
//  Created by Can on 19.08.2022.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @ObservedObject var audioBox = AudioBox()
    @State var hasMicAccess = false
    @State var displayNotification = false
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ZStack {
                    Image("bg")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Image("penguin_01")
                            .padding(.top, geometry.size.height * 0.1)
                        ZStack {
                            Image("Overlay")
                                .resizable()
                                .edgesIgnoringSafeArea(.bottom)
                            VStack {
                                Text("00:00:00")
                                    .font(Font.custom("Menlo Bold", size: 24.0))
                                    .foregroundColor(Color(red: 0.1, green: 0.28, blue: 0.52))
                                    .padding(.top)
                                Spacer()
                                VStack {
                                    HStack {
                                        Button {
                                            // record audio
                                            if audioBox.status == .stopped {
                                                if hasMicAccess {
                                                    audioBox.record()
                                                } else {
                                                    requestMicrophoneAccess()
                                                }
                                            } else {
                                                audioBox.stopRecording()
                                            }
                                        } label: {
                                            Image(audioBox.status == .recording ? "button-play-active": "button-record-inactive")
                                        }
                                        Button {
                                            // play audio
                                        } label: {
                                            Image( "button-play-inactive")
                                        }
                                    }
                                    .padding([.leading, .trailing])
                                }
                                .padding(.top, 50)
                                Spacer()
                            }
                        }
                    }
                }
                .onAppear {
                    audioBox.setupRecorder()
                }
                .alert(isPresented: $displayNotification) {
                    Alert(title: Text("Requires Microphone Access"),
                          message: Text("Go to Settings > PenguinPet > Allow PenguinPet to Access Microphone. \nSet switch to enable."),
                          dismissButton: .default(Text("Ok")))
                }
            }.navigationBarHidden(true)
        }
    }
    
    private func requestMicrophoneAccess() {
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { granted in
            hasMicAccess = granted
            if granted {
                audioBox.record()
            } else {
                displayNotification = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
