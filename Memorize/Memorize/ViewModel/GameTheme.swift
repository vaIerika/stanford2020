//
//  GameTheme.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 18/06/2020.
//

import Foundation
import SwiftUI

struct Theme {
    var name: String
    var emojis: [String]
    var cardsNumber: Int?
    var color: Color
    
    static let cats = Theme(name: "Cats", emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"], color: .yellow)
    static let techno = Theme(name: "Technology", emojis: ["🤖", "👾", "🦾", "🦿", "🎮", "🖲"], cardsNumber: 6, color: .black)
    static let zodiac = Theme(name: "Signs of zodiac", emojis: ["♌️", "♍️", "♏️", "♓️", "♉️", "♈️", "⛎", "♒️", "♋️", "⛎", "♊️", "♑️"], color: .purple)
    static let animals = Theme(name: "Animals", emojis: ["🐶", "🐨", "🦁", "🐮", "🐷", "🐯", "🐼", "🦊", "🐻", "🐰"], color: .orange)
    static let vegetables = Theme(name: "Vegetables", emojis: ["🥦", "🍅", "🌶", "🌽", "🥕", "🥬", "🥒", "🧄", "🍆", "🧅"], color: .green)
    static let flowers = Theme(name: "Flowers", emojis: ["🌷", "🌺", "🌹", "🌸", "🌼", "🌻", "💐"], cardsNumber: 7, color: .pink)
    
    static var themes = [cats, techno, zodiac, animals, vegetables, flowers]
}
