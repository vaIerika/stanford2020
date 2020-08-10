//
//  GameTheme.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 18/06/2020.
//

import Foundation
import SwiftUI

struct Theme: Codable {
    var name: String
    var emojis: [String]
    
    // MARK: -  Assignment 1 & 2.
    /// - No need to for implementation `Codable`
    /// - Random number of cards
    /// - Color as a SwiftUI View
/*
    var cardsNumber: Int?
    var color: Color
     
    static let cats = Theme(name: "Cats", emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"], color: .yellow)
    static let techno = Theme(name: "Technology", emojis: ["🤖", "👾", "🦾", "🦿", "🎮", "🖲"], cardsNumber: 6, color: .black)
    static let zodiac = Theme(name: "Signs of zodiac", emojis: ["♌️", "♍️", "♏️", "♓️", "♉️", "♈️", "⛎", "♒️", "♋️", "⛎", "♊️", "♑️"], color: .purple)
    static let animals = Theme(name: "Animals", emojis: ["🐶", "🐨", "🦁", "🐮", "🐷", "🐯", "🐼", "🦊", "🐻", "🐰"], color: .orange)
    static let vegetables = Theme(name: "Vegetables", emojis: ["🥦", "🍅", "🌶", "🌽", "🥕", "🥬", "🥒", "🧄", "🍆", "🧅"], cardsNumber: 10, color: .green)
    static let flowers = Theme(name: "Flowers", emojis: ["🌷", "🌺", "🌹", "🌸", "🌼", "🌻", "💐"], cardsNumber: 7, color: .pink)
*/

    // MARK: -  Assignment 5.
    /// - Assign struct  to  a`Codable` protocol
    /// - Each theme has a pre-defined number of cards
    /// - Color needs to be replaced with UIColor to make it Codable
    
    var cardsNumber: Int
    
    // Use a struct RGB which is conformed to Codable protocol
    var color: UIColor.RGB
    
    // For JSON representation of the theme in the console
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static let cats = Theme(name: "Cats", emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"], cardsNumber: 8, color: .init(red: 100/255, green: 200/255, blue: 200/255, alpha: 1))
    static let techno = Theme(name: "Technology", emojis: ["🤖", "👾", "🦾", "🦿", "🎮", "🖲"], cardsNumber: 6, color: .init(red: 5/255, green: 5/255, blue: 5/255, alpha: 1))
    static let zodiac = Theme(name: "Signs of zodiac", emojis: ["♌️", "♍️", "♏️", "♓️", "♉️", "♈️", "⛎", "♒️", "♋️", "⛎", "♊️", "♑️"], cardsNumber: 12, color: .init(red: 255/255, green: 60/255, blue: 150/255, alpha: 1))
    static let animals = Theme(name: "Animals", emojis: ["🐶", "🐨", "🦁", "🐮", "🐷", "🐯", "🐼", "🦊", "🐻", "🐰"], cardsNumber: 10, color: .init(red: 200/255, green: 81/255, blue: 81/255, alpha: 1))
    static let vegetables = Theme(name: "Vegetables", emojis: ["🥦", "🍅", "🌶", "🌽", "🥕", "🥬", "🥒", "🧄", "🍆", "🧅"], cardsNumber: 10, color: .init(red: 61/255, green: 201/255, blue: 81/255, alpha: 1))
    static let flowers = Theme(name: "Flowers", emojis: ["🌷", "🌺", "🌹", "🌸", "🌼", "🌻", "💐"], cardsNumber: 7, color: .init(red: 255/255, green: 10/255, blue: 15/255, alpha: 1))
    
    static var themes = [cats, techno, zodiac, animals, vegetables, flowers]
}
