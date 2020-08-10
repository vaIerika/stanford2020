//
//  Set+Identifiable.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 07/08/2020.
//

import Foundation

extension Set where Element: Identifiable {
    mutating func toggleMatching(_ element: Element) {
        if contains(matching: element) {
           remove(element)
        } else {
           insert(element)
        }
    }
}
