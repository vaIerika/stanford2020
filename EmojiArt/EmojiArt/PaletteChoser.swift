//
//  PaletteChoser.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 12/08/2020.
//

import SwiftUI

struct PaletteChoser: View {
    @ObservedObject var document: EmojiArtDocument
    @Binding var chosenPalette: String
    @State private var showPaletteEditor = false
    
    var body: some View {
        HStack {
            Stepper {
                chosenPalette = document.palette(after: chosenPalette)
            } onDecrement: {
                chosenPalette = document.palette(before: chosenPalette)
            } label: { EmptyView() }
            
            Text(document.paletteNames[chosenPalette] ?? "")
            Image(systemName: "keyboard")
                .imageScale(.large)
                .onTapGesture {
                    showPaletteEditor = true
                }
                .popover(isPresented: $showPaletteEditor) {
                //.sheet(isPresented: $showPaletteEditor) {
                    PaletteEditor(isShowing: $showPaletteEditor, chosenPalette: $chosenPalette)
                        .environmentObject(document)
                        .frame(minWidth: 300, minHeight: 400)
                }
        }
        .fixedSize(horizontal: true, vertical: false)
    }
}

struct PaletteEditor: View {
    @EnvironmentObject var document: EmojiArtDocument
    
    // Two variants of closing an sheet()
    @Environment(\.presentationMode) var presentationMode
    @Binding var isShowing: Bool
    
    @Binding var chosenPalette: String
    @State private var paletteName = ""
    @State private var emojisToAdd = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Text("Palette Editor")
                    .font(.headline)
                    .padding()
                HStack {
                    Spacer()
                    // Button("Done") { isShowing = false }
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                        .padding()
                }
            }
            Divider()
            
            Form {
                Section {
                    TextField("Palette Name", text: $paletteName, onEditingChanged: { began in
                        if !began {
                            document.renamePalette(chosenPalette, to: paletteName)
                        }
                    })
                    TextField("Add Emoji", text: $emojisToAdd, onEditingChanged: { began in
                        if !began {
                            chosenPalette = document.addEmoji(emojisToAdd, toPalette: chosenPalette)
                            emojisToAdd = ""
                        }
                    })
                }
                Section(header: Text("Remove Emoji")) {
                    Grid(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: fontSize))
                                .onTapGesture {
                                    chosenPalette = document.removeEmoji(emoji, fromPalette: chosenPalette)
                                }
                    }
                    .frame(height: height)
                }
            }
        }
        .onAppear {
            paletteName = document.paletteNames[chosenPalette] ?? ""
        }
    }
    
    // MARK: - Drawing constants
    var height: CGFloat {
        CGFloat((chosenPalette.count - 1) / 6) * 70 + 70
    }
    let fontSize: CGFloat = 40
}


struct PaletteChoser_Previews: PreviewProvider {
    static var previews: some View {
        PaletteChoser(document: EmojiArtDocument(), chosenPalette: Binding.constant("Animals"))
    }
}
