//
//  Cardify.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 21/06/2020.
//

import Foundation
import SwiftUI

struct Cardify: ViewModifier {
    var isFaceUp: Bool
    var themeColor: Color
    
    var gradientFromThemeColor: LinearGradient {
        return LinearGradient(gradient: Gradient(colors: [themeColor, themeColor.opacity(0.4)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    func body(content: Content) -> some View {      /// content is ZStack in this app
        ZStack {
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                    .fill(Color.white)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius)
                .fill(gradientFromThemeColor)
            }
        }
    }
    // MARK: - Drawing Contraits
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

extension View {
    func cardify(isFaceUp: Bool, themeColor: Color) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp, themeColor: themeColor))
    }
}
