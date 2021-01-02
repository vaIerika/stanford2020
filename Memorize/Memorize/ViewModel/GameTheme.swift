//
//  GameTheme.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 18/06/2020.
//

import Foundation
import SwiftUI

struct Theme: Codable, Identifiable {
    
    //MARK: - Assignment 6.
    /// - Property id and Identifiable protocol
    var id = UUID()
    
    var name: String
    var emojis: [String]
    
    //MARK: - Assignment 6.
    /// - Property to collect emojis that had been removed 
    var removedEmojis: [String]
    
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
    
    // MARK: - Assignment 6.
    /// - Use `getRGB` method to get a codable color
    /// - Apple standard colors library
    /// - `removedEmojis` array
    static let cats = Theme(name: "Cats", emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"], removedEmojis: [], cardsNumber: 8, color: UIColor.getRGB(.orange))
    static let techno = Theme(name: "Technology", emojis: ["🤖", "👾", "🦾", "🦿", "🎮", "🖲"], removedEmojis: [], cardsNumber: 6, color: UIColor.getRGB(.cyan))
    static let zodiac = Theme(name: "Signs of zodiac", emojis: ["♌️", "♍️", "♏️", "♓️", "♉️", "♈️", "⛎", "♒️", "♋️", "♐️", "♊️", "♑️"], removedEmojis: [], cardsNumber: 12, color: UIColor.getRGB(.purple))
    static let animals = Theme(name: "Animals", emojis: ["🐶", "🐨", "🦁", "🐮", "🐷", "🐯", "🐼", "🦊", "🐻", "🐰"], removedEmojis: [], cardsNumber: 10, color: UIColor.getRGB(.brown))
    static let vegetables = Theme(name: "Vegetables", emojis: ["🥦", "🍅", "🌶", "🌽", "🥕", "🥬", "🥒", "🧄", "🍆", "🧅"], removedEmojis: [], cardsNumber: 10, color: UIColor.getRGB(.green))
    static let flowers = Theme(name: "Flowers", emojis: ["🌷", "🌺", "🌹", "🌸", "🌼", "🌻", "💐"], removedEmojis: [], cardsNumber: 7, color: UIColor.getRGB(.red))
    
    static var themes = [cats, techno, zodiac, animals, vegetables, flowers]
}
