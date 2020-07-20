//
//  Cardify.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 21/06/2020.
//

import Foundation
import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    
    init(isFaceUp: Bool, themeColor: Color) {
        self.themeColor = themeColor
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    var themeColor: Color
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    var gradientFromThemeColor: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [themeColor, themeColor.opacity(themeColorOpacity)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    func body(content: Content) -> some View {      /// content is ZStack in this app
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                    .fill(Color.white)
                content
            }.opacity(isFaceUp ? 1 : 0)
            
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(gradientFromThemeColor)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    // MARK: - Drawing Constraits
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
    private let themeColorOpacity = 0.4
}

extension View {
    func cardify(isFaceUp: Bool, themeColor: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, themeColor: themeColor))
    }
}
