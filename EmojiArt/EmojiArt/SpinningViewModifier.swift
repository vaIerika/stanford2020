//
//  SpinningViewModifier.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 12/08/2020.
//

import SwiftUI

struct Spinning: ViewModifier {
    @State var isVisible = false
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear { isVisible = true }
           // .onDisappear { isVisible = false }
    }
}

extension View {
    func spinning() -> some View {
        self.modifier(Spinning())
    }
}
