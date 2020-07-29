//
//  AnimatableSystemFontModifier.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 28/07/2020.
//

import SwiftUI

struct AnimatableSystemFontModifier: AnimatableModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular
    var design: Font.Design = .default
    
    func body(content: Content) -> some View {
        content.font(Font.system(size: size, weight: weight, design: design))
    }
    
    var animatableData: CGFloat {
        get { size }
        set { size = newValue }
    }
}

extension View {
    func font(animatableWithSize size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.modifier(AnimatableSystemFontModifier(size: size, weight: weight, design: design))
    }
}
