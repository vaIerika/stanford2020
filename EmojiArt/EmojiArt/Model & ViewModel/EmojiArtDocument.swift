//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 24/07/2020.
//

import SwiftUI

// ViewModel
class EmojiArtDocument: ObservableObject {

    static let palette: String = "🐝🦋🐢🐏🐑🦙🐄"

    @Published private var emojiArt: EmojiArt = EmojiArt() {
        didSet {
            //print("json = \(emojiArt.json?.utf8 ?? "nil")")
            UserDefaults.standard.set(emojiArt.json, forKey: EmojiArtDocument.untitled)
        }
    }

    private static let untitled = "EmojiArtDocument.Untitled"
    
    init() {
        emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: EmojiArtDocument.untitled)) ?? EmojiArt()
        fetchBackgroundImageData()
    }
    
    @Published private(set) var backgroundImage: UIImage?

    var emojis: [EmojiArt.Emoji] { emojiArt.emojis }

    // MARK: - Intents
    func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
        emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
    }
    
    func removeEmoji(_ emoji: EmojiArt.Emoji) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis.remove(at: index)
        }
    }

    func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }

    func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.firstIndex(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
        }
    }

    func setBackgroundURL(_ url: URL?) {
        emojiArt.backgroundURL = url?.imageURL
        fetchBackgroundImageData()
    }

    private func fetchBackgroundImageData() {
        backgroundImage = nil   /// if image is heavy, it will show a user that we're processing

        if let url = emojiArt.backgroundURL {   /// more common to use URLSessions
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {     /// can take a lot of time
                    DispatchQueue.main.async {
                        if url == self.emojiArt.backgroundURL {     /// in case user dragged another image faster then it loaded
                            self.backgroundImage = UIImage(data: imageData)  /// UI cannot be happing on bg thread
                        }
                    }
                }
            }
        }
    }
}

extension EmojiArt.Emoji {
    var fontSize: CGFloat { CGFloat(self.size) }
    var location: CGPoint { CGPoint(x: CGFloat(x), y: CGFloat(y)) }
}

