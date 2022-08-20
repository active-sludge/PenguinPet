//
//  AudioSettings.swift
//  PenguinPet
//
//  Created by Can on 20.08.2022.
//

import SwiftUI

struct AudioSettings: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var audioBox: AudioBox
    
    init(audioBox: AudioBox) {
        self.audioBox = audioBox
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    VStack {
                        HStack {
                            Text("Pitch")
                                .foregroundColor(.black)
                            Slider(value: $audioBox.pitchEffect.pitch, in: -2400...2400)
                        }
                        .padding([.leading, .trailing], 20)
                        .padding(.bottom)
                        HStack {
                            Text("Reverb:")
                                .foregroundColor(.black)
                            Slider(value: $audioBox.reverbEffect.wetDryMix, in: 1...100)
                        }
                        .padding([.leading, .trailing], 20)
                        .padding(.bottom)
                    }
                    Spacer()
                        .frame(maxHeight: geometry.size.height * 0.5)
                    HStack {
                        Spacer()
                        Button {
                            // action
                            audioBox.stopPlayback()
                            audioBox.reverbEffect.wetDryMix = 50
                            audioBox.pitchEffect.pitch = 1
                        } label: {
                            Text("Reset")
                                .padding(.all, 5)
                                .frame(maxWidth: 85.0)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(5.0)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                                .padding(.bottom)
                        }
                        Spacer()
                        Button {
                            // action
                            audioBox.play()
                        } label: {
                            Text("Preview")
                                .padding(.all, 5)
                                .frame(maxWidth: 85.0)
                                .background(Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(5.0)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 2))
                                .padding(.bottom)
                        }
                        Spacer()
                    }
                    
                    ZStack {
                        Image("Overlay")
                            .resizable()
                            .edgesIgnoringSafeArea(.bottom)
                        VStack {
                            VStack {
                                
                            }
                            Spacer()
                            VStack {
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Text("Done")
                                        .font(.system(size: 26.0))
                                        .padding(.all, 5)
                                        .frame(maxWidth: 85.0)
                                        .background(Color.white)
                                        .foregroundColor(.black)
                                        .cornerRadius(10.0)
                                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 2))
                                }
                                
                            }
                            .padding(.top, 50)
                            Spacer()
                        }
                    }
                }
                .padding(.top)
            }.navigationBarHidden(true)
        }
    }
}

struct AudioSettingsAudioEffects_Previews: PreviewProvider {
    static var previews: some View {
        AudioSettings(audioBox: AudioBox())
    }
}

