//
//  CardView.swift
//  CentriFugue
//
//  Created by Graham Nadel on 2/15/24.
//

import Foundation
import SwiftUI

struct CardView: View {
    let instrument: String
    
    var body: some View {
        GeometryReader { geometry in
            background(with: geometry.size)
        }
    }
}

private extension CardView {
    private func background(with size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
            //            TODO: add style
                .foregroundStyle(foregroundStyle)
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(lineWidth: size.width * Constants.Background.borderLengthFactor)
                .foregroundColor(.white)
            Text(instrument)
                .scaledToFill()
                .minimumScaleFactor(0.5)
                .font(.system(size: size.width * Constants.Font.textWidthFactor))
//                .frame(width: size.width * Constants.Font.textWidthFactor, height: size.height * Constants.Font.textWidthFactor)
        }
    }
    
    private var foregroundStyle: LinearGradient {
        return LinearGradient(colors: [.red, .white], startPoint: .bottom, endPoint: .top)
    }
}

fileprivate enum Constants {
    enum Background {
        static let cornerRadius = 12.0
        static let borderLengthFactor = 0.005
    }
    enum Font {
        static let textWidthFactor = 0.75
    }
}

#Preview {
    CardView(instrument: "🎸")
}
