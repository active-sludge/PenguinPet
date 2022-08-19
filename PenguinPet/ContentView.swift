//
//  SwiftUIView.swift
//  PenguinPet
//
//  Created by Can on 19.08.2022.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
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
                                        } label: {
                                            Image("button-record-inactive")
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
            }.navigationBarHidden(true)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
