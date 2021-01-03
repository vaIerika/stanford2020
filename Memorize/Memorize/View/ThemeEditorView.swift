//
//  ThemeEditorView.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 30/12/2020.
//

import SwiftUI

// MARK: - Assignment 6

struct ThemeEditorView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var theme: Theme?
    var updateChanges: (Theme) -> Void
    
    @State private var themeToAdd: Theme
    @State private var emojiToAdd = ""
    private var colors: [UIColor] = [.red, .blue, .green, .purple, .yellow, .magenta, .orange, .cyan, .brown]
    private var validData: Bool {
        !themeToAdd.name.isEmpty && themeToAdd.emojis.count > 1 && themeToAdd.cardsNumber > 1
    }
    
    init(theme: Binding<Theme?>, updateChanges: @escaping (Theme) -> Void) {
        self._theme = theme
        self.updateChanges = updateChanges
        self._themeToAdd = State(wrappedValue: theme.wrappedValue ?? Theme(name: "Unknown", emojis: [], removedEmojis: [], cardsNumber: 0, color: UIColor.getRGB(.red)))
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    self.presentationMode.wrappedValue.dismiss()
                }
                Spacer()
                Button("Save") {
                    updateChanges(themeToAdd)
                    self.presentationMode.wrappedValue.dismiss()
                }.disabled(!validData)
            }
            .padding([.leading, .trailing, .top], 15)
            
            Form {
                Section(header: Text("Set title")) {
                    TextField("Name theme", text: $themeToAdd.name)
                }
                Section(header: Text("Theme color")) {
                    Grid(colors, id: \.self) { color in
                        ZStack {
                            Circle().fill(Color(color)).frame(width: 35, height: 35)
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.white)
                                .opacity(UIColor(themeToAdd.color) == color ? 1 : 0)
                        }
                        .onTapGesture {
                            themeToAdd.color = UIColor.getRGB(color)
                        }
                    }.frame(minHeight: 20, idealHeight: 80, maxHeight: 100)
                }
                Section(header: Text("Add emoji")) {
                    HStack {
                        TextField("Emoji", text: $emojiToAdd)
                        Button("Add") {
                            for character in emojiToAdd {
                                if !themeToAdd.emojis.contains(String(character)) {
                                    themeToAdd.emojis.append(String(character))
                                }
                            }
                            emojiToAdd = ""
                            updateCardsNumber()
                        }.disabled(emojiToAdd.isEmpty)
                    }
                }
                if themeToAdd.emojis.count > 1 {
                    Section(header: Text("Number of cards to play")) {
                        Stepper(value: $themeToAdd.cardsNumber, in: 2...themeToAdd.emojis.count) {
                            Text("\(themeToAdd.cardsNumber) pairs")
                        }
                    }
                }
                Section(header: Text("Emojis to play"), footer: Text("Tap emoji to exclude")) {
                    Grid(themeToAdd.emojis, id: \.self) { emoji in
                        Text(emoji)
                            .frame(width: 30, height: 30)
                            .onTapGesture {
                                withAnimation {
                                    removeEmoji(emoji)
                                }
                            }
                    }.frame(minHeight: 20, idealHeight: 100, maxHeight: 300)
                }
                if !themeToAdd.removedEmojis.isEmpty {
                    Section(header: Text("Removed emojis"), footer: Text("Tap emoji to include in the game")) {
                        Grid(themeToAdd.removedEmojis, id: \.self) { emoji in
                            Text(emoji)
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        returnEmoji(emoji)
                                    }
                                }
                        }.frame(minHeight: 20, idealHeight: 100, maxHeight: 300)
                    }
                }
            }
        }
    }
    
    private func updateCardsNumber() {
        themeToAdd.cardsNumber = themeToAdd.emojis.count
    }
    
    private func removeEmoji(_ emoji: String) {
        if let index = themeToAdd.emojis.firstIndex(of: emoji) {
            themeToAdd.removedEmojis.append(themeToAdd.emojis.remove(at: index))
            updateCardsNumber()
        }
    }
    
    private func returnEmoji(_ emoji: String) {
        if let index = themeToAdd.removedEmojis.firstIndex(of: emoji) {
            themeToAdd.emojis.append(themeToAdd.removedEmojis.remove(at: index))
            updateCardsNumber()
        }
    }
}

struct ThemeEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ThemeEditorView(theme: Binding.constant(Theme(name: "Cats", emojis: ["😺", "😸", "😹", "😻", "🙀", "😿", "😾", "😼"], removedEmojis: [], cardsNumber: 8, color: .init(red: 100/255, green: 200/255, blue: 200/255, alpha: 1)))) { theme in
            print(theme)
        }
    }
}
