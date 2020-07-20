//
//  AnyTransition+offsetWithOpacity.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 20/07/2020.
//

import SwiftUI

extension AnyTransition {
    static func offsetWithOpacity(width: CGFloat, height: CGFloat) -> AnyTransition {
        AnyTransition.offset(CGSize(width: width, height: height)).combined(with: .opacity)
    }
}
