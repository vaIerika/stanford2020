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
    @StateObject var store = EmojiArtDocumentStore(named: "Emoji Art")
    
    var body: some Scene {
        WindowGroup {
            //EmojiArtDocumentView(document: document)
            
            // Lecture 10
            EmojiArtDocumentChooser()
                .environmentObject(store)
        }
    }
}
