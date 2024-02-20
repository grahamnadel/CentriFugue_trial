//
//  RecordShapeView.swift
//  Pods
//
//  Created by Graham Nadel on 2/13/24.
//

import Foundation
import SwiftUI

struct RecordButtonView: View {
    @ObservedObject var audioRecorder: AudioRecorder
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white, lineWidth: 6)
                .frame(width: 85, height: 85)
            if audioRecorder.recording {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 40, height: 40)
            } else {
                Circle()
                    .fill(Color.red)
                    .frame(width: 70, height: 70)
            }
        }
    }
}
