//
//  ThemesListView.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 29/12/2020.
//

import SwiftUI

// MARK: - Assignment 6

struct ThemesListView: View {
    @ObservedObject var viewModelThemes: Themes
    @State var showingUpdateThemeView = false
    @State var editMode: EditMode = .inactive
    @State private var selectedTheme: Theme?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModelThemes.savedThemes) { theme in
                    NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame(theme: theme))) {
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(Color(theme.color))
                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                                    .opacity(editMode.isEditing ? 1 : 0)
                                    .onTapGesture {
                                        selectedTheme = theme
                                        showingUpdateThemeView = true
                                    }
                            }.frame(width: 25, height: 25)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(theme.name)
                                    .font(.headline)
                                Text(showListOfEmojis(theme: theme))
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                        }.padding(5)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModelThemes.savedThemes[$0] }.forEach { theme in
                        viewModelThemes.removeTheme(theme)
                    }
                }
            }
            .sheet(isPresented: $showingUpdateThemeView) {
                ThemeEditorView(theme: $selectedTheme) { updatedTheme in
                    viewModelThemes.addTheme(updatedTheme)
                    editMode = .inactive
                }
            }
            
            .navigationBarTitle("Memorize")
            .navigationBarItems(leading: Button(action: { addNewTheme() })
                                        { Image(systemName: "plus").frame(width: 50, height: 50) },
                                trailing: EditButton().frame(width: 50, height: 50)
            )
            .environment(\.editMode, $editMode)
        }
    }
    
    private func showListOfEmojis(theme: Theme) -> String {
        let pairsStr = theme.cardsNumber == theme.emojis.count ? "" : "\(theme.cardsNumber) pairs from "
        return pairsStr + String(theme.emojis.joined())
    }
    
    private func addNewTheme() {
        selectedTheme = nil
        showingUpdateThemeView = true
    }
}

struct ThemesListView_Previews: PreviewProvider {
    static var previews: some View {
        ThemesListView(viewModelThemes: Themes())
    }
}
