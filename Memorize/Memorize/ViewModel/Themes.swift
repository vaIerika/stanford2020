//
//  Themes.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 29/12/2020.
//

import SwiftUI
import Combine

// MARK: - Assignment 6

class Themes: ObservableObject {
    @Published private(set) var savedThemes: [Theme]
    static let saveKey = "SavedThemesForEmojiMemoryGame"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            if let decoded = try? JSONDecoder().decode([Theme].self, from: data) {
                self.savedThemes = decoded
                return
            }
        }
        self.savedThemes = [Theme.cats, Theme.techno, Theme.zodiac, Theme.animals, Theme.vegetables, Theme.flowers]
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(savedThemes) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    func addTheme(_ theme: Theme) {
        if let index = savedThemes.firstIndex(matching: theme) {
            savedThemes[index] = theme
        } else {
            savedThemes.append(theme)
        }
        save()
    }
    
    func removeTheme(_ theme: Theme) {
        if let index = savedThemes.firstIndex(matching: theme) {
            savedThemes.remove(at: index)
                 save()
        }
    }
}
