//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 24/07/2020.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    //@StateObject var document = EmojiArtDocument()
    
    // Lecture 10
    // @StateObject var store = EmojiArtDocumentStore(named: "Emoji Art")
    
    // Lecture 13
    @StateObject var store = EmojiArtDocumentStore(directory: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
    
    var body: some Scene {
        WindowGroup {
            //EmojiArtDocumentView(document: document)
            
            // Lecture 10
            EmojiArtDocumentChooser()
                .environmentObject(store)
        }
    }
}
