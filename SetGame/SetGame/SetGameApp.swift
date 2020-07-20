//
//  SetGameApp.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 29/06/2020.
//

import SwiftUI

@main
struct SetGameApp: App {
    @StateObject var viewModel = ClassicSetGame(cards: GeometricCard.generateAll())
    
    var body: some Scene {
        WindowGroup {
            ContentView(game: viewModel)
        }
    }
}
