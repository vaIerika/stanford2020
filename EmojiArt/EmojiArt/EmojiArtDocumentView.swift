//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Valerie 👩🏼‍💻 on 24/07/2020.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    @State private var chosenPalette = ""
    @State private var selectedEmojis: Set<EmojiArt.Emoji> = []
    
    var body: some View {
        VStack {
            HStack {
                PaletteChoser(document: document, chosenPalette: $chosenPalette)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(chosenPalette.map { String($0) }, id: \.self) { emoji in
                            Text(emoji)
                                .font(Font.system(size: defaultEmojiSize))
                                .onDrag { NSItemProvider(object: emoji as NSString) }
                        }
                    }
                }
                
                
                // Delete emojis from the view
                Button(action: {
                    selectedEmojis.forEach { emoji in
                        document.removeEmoji(emoji)
                        selectedEmojis.remove(emoji)
                    }
                }) {
                  Image(systemName: "trash.fill")
                    .font(.headline)
                    .foregroundColor(selectedEmojis.isEmpty ? .gray : .blue)
                    .padding()
                }
            }
            .onAppear { chosenPalette = document.defaultPalette }

            GeometryReader { geometry in
                ZStack {
                    Color.white.overlay(
                        OptionalImage(uiImage: document.backgroundImage)
                            .scaleEffect(zoomScale)
                            .offset(panOffset)
                    )
                    .gesture(doubleTapToZoom(in: geometry.size))
                    
                    if isLoading {
                        Image(systemName: "hourglass")
                            .imageScale(.large)
                            .spinning()
                    } else {
                        ForEach(document.emojis) { emoji in
                            Text(emoji.text)
                                .font(animatableWithSize: emoji.fontSize * zoomScale(for: emoji))
                                .background(
                                    Circle()
                                        .stroke(Color.red)
                                        .opacity(isSelected(emoji) ? 1 : 0)
                                )
                                .gesture(dragEmojisGesture(for: emoji))
                                .gesture(longPressToRemove(emoji))
                                .position(position(for: emoji, in: geometry.size))
                                .onTapGesture {
                                    selectedEmojis.toggleMatching(emoji)
                                }
                        }
                    }
                }
                .gesture(tapBgToDeselectOrZoom(in: geometry.size))
                .clipped()
                .gesture(panGesture())
                .gesture(zoomGesture())
                .edgesIgnoringSafeArea([.horizontal, .bottom])
                
                // Zoom to fit on a change of bg image
                .onReceive(document.$backgroundImage) { image in
                    zoomToFit(image, in: geometry.size)
                }
                .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
                    var location = CGPoint(x: location.x, y: geometry.convert(location, from: .global).y)
                    location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
                    location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
                    location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
                    return self.drop(providers: providers, at: location)
                }
            }
        }
    }
    
    var isLoading: Bool {
        document.backgroundURL != nil && document.backgroundImage == nil
    }
    
    private func longPressToRemove(_ emoji: EmojiArt.Emoji) -> some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onEnded { _ in
                document.removeEmoji(emoji)
            }
    }
    
    private func isSelected(_ emoji: EmojiArt.Emoji) -> Bool {
        selectedEmojis.contains(matching: emoji)
    }
    
    
    private func tapBgToDeselectOrZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 1)
            .exclusively(before: doubleTapToZoom(in: size))
            .onEnded { _ in
                withAnimation(.linear(duration: 0.2)) {
                    selectedEmojis.removeAll()
                }
            }
    }
 
    @State private var steadyStateDragEmojisOffset: CGSize = .zero
    @GestureState private var gestureDragEmojisOffset: CGSize = .zero
    
    private func dragEmojisGesture(for emoji: EmojiArt.Emoji) -> some Gesture {
        
        // Extra credit
        let isEmojiPartOfSelection = isSelected(emoji)
        
        return DragGesture()
            .updating($gestureDragEmojisOffset) { latestDragGestureValue, gestureDragEmojisOffset, transition in
                gestureDragEmojisOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                let distanceDragged = finalDragGestureValue.translation / zoomScale
                
                // Extra credit `if-else`
                if isEmojiPartOfSelection {
                
                    for emoji in selectedEmojis {
                        withAnimation {
                            document.moveEmoji(emoji, by: distanceDragged)
                        }
                    }
                } else {
                    document.moveEmoji(emoji, by: distanceDragged)
                }
            }
    }
    
    @State private var steadyStateZoomScale: CGFloat = 1.0
    @GestureState private var gestureZoomScale: CGFloat = 1.0   /// can be different type
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * (selectedEmojis.isEmpty ? gestureZoomScale : 1)
    }
    
    private func zoomScale(for emoji: EmojiArt.Emoji) -> CGFloat {
        if isSelected(emoji) {
            return steadyStateZoomScale * gestureZoomScale
        } else {
            return zoomScale
        }
    }
    
    // MARK: - Non-discrete gesture
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale, body: { latestGestureScale, gestureZoomScale, transaction in
                gestureZoomScale = latestGestureScale
            })
            .onEnded { finalGestureScale in
                if selectedEmojis.isEmpty {
                    steadyStateZoomScale *= finalGestureScale
                } else {
                    selectedEmojis.forEach { emoji in
                        document.scaleEmoji(emoji, by: finalGestureScale)
                    }
                }
            }
    }
    
    @State private var steadyStatePanOffset: CGSize = .zero
    @GestureState private var gesturePanOffset: CGSize = .zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0 {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }

    private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
        var location = emoji.location
        location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
        location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
        location = CGPoint(x: location.x + panOffset.width, y: location.y + panOffset.height)
        return location
    }

    private func drop(providers: [NSItemProvider], at location: CGPoint) -> Bool {
        var found = providers.loadFirstObject(ofType: URL.self) { url in
            //self.document.setBackgroundURL(url)
            document.backgroundURL = url
        }
        if !found {
            found = providers.loadObjects(ofType: String.self) { string in
                document.addEmoji(string, at: location, size: defaultEmojiSize)
            }
        }
        return found
    }

    private let defaultEmojiSize: CGFloat = 40
}



struct EmojiArtDocumentView_Previews: PreviewProvider {
    static var previews: some View {
        let document = EmojiArtDocument()
        return EmojiArtDocumentView(document: document)
    }
}
