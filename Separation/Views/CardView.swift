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
            Group {
                RoundedRectangle(cornerRadius: 12)
                //            TODO: add style
                    .foregroundStyle(foregroundStyle)
                
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: size.width * Constants.Background.borderLengthFactor)
                    .foregroundColor(.white)
            }
                .frame(width: size.width * Constants.Background.sizeScaleFactor, height: size.height * Constants.Background.heightScaleFactor)
            Text(instrument)
//                .scaledToFill()
//                .aspectRatio(0.75, contentMode: .fit)
//                .minimumScaleFactor(0.5)
                .font(.system(size: size.width * Constants.Font.textWidthFactor))
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
        static let sizeScaleFactor = 1.0
        static let heightScaleFactor = 0.5
    }
    enum Font {
        static let textWidthFactor = 0.75
    }
}

#Preview {
    CardView(instrument: "🎸")
}
