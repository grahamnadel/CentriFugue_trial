//
//  AudioProgressView.swift
//  CentriFugue_trial
//
//  Created by Graham Nadel on 2/20/24.
//

import Foundation
import SwiftUI

struct AudioProgressView: View {
    @ObservedObject var audioPlayer: AudioPlayer
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height / 2))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height / 2))
                }
                .stroke(Color.red, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                
                //Circle to track progress
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
//                    .offset(x: (audioPlayer.currentPosition ?? 0.0) * geometry.size.width - 10, y: geometry.size.height / 2 - 10)
                    .animation(.easeInOut(duration: 0.5))
            }
            .frame(height: 40)
        }
        .padding()
//        .gesture(DragGesture()
//            .onChanged({ value in
//                self.progress = min(max(value.location.x / UIScreen.main.bounds.width), 0.0)
//            })
//        )
    }
}

//#Preview {
//    AudioProgressView(audioPlayer: 0.075)
//}
