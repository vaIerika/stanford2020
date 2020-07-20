//
//  ContentView.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 29/06/2020.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: ClassicSetGame
    
    private let layots = [
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50)),
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                // MARK: Background
                LinearGradient(gradient: Gradient(colors: [.white, Color.gray.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)

                // MARK: Cards
                VStack {
                    GeometryReader { geometry in
                        ScrollView {
                            LazyVGrid(columns: layots) {
                                ForEach(game.cardsInGame) { card  in
                                    CardView(card: card)
                                        .animation(.easeInOut(duration: 0.6))
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 1)) {
                                                self.game.choose(card: card)
                                            }
                                        }
                                        .scaleEffect(card.isSelected ? cardScaleEffectMax : 1)
                                        .transition(.offsetWithOpacity(width: 0, height: geometry.size.height))
                                    
                                        // MARK: - Required Task #2. Changed with <.transition()> above for Extra Credit
                                        //.transition(AnyTransition.offset(locationRandomizer(for: CGSize(width: geometry.size.width, height: geometry.size.height))))
                                }
                            }
                        }
                        .onAppear {
                            withAnimation {
                                game.dealInitialCards()
                            }
                        }
                    }
                
                    Spacer()
                
                    // MARK: Deck and discard pile
                    HStack {
                        ZStack {
                            ForEach(game.deck) { card in
                                CardView(card: card, untidy: true, played: false)
                                    .frame(width: deckSize, height: deckSize)
                                    .onTapGesture { withAnimation { game.dealCards() } }
                            }
                        }
                        Spacer()
                        ZStack {
                            ForEach(game.discardPile) { card in
                                CardView(card: card, untidy: true)
                                    .frame(width: deckSize, height: deckSize)
                            }
                        }
                    }
                }
                .padding(padding)
            }
            
            // MARK: Actions
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: itemSpacing) {
                        Button(action: { withAnimation { game.restart() } },
                               label: { Text("New Game") })
                        Divider()
                        Text("Score: \(game.score)")
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .fixedSize(horizontal: true, vertical: false)
                        Divider()
                        Button(action: { withAnimation(.easeIn(duration: 0.2)) { game.dealCards() } },
                               label: { Text("Add cards") })
                    }
                    .foregroundColor(.pink)
                }
            }
        }
    }
    
    // MARK: - Required Task #2
    /*
    private func locationRandomizer(for canvas: CGSize) -> CGSize {
        
        // Random coordimates out of the canvas
        let widthRange = [
            -Int(canvas.width * 1.5) ..<
            -Int(canvas.width * 1.25),
            Int(canvas.width * 1.25) ..<
            Int(canvas.width * 1.5)
        ].shuffled()
        
        let heightRange = [
            -Int(canvas.height * 1.5) ..<
            -Int(canvas.height * 1.25),
            Int(canvas.height * 1.25) ..<
            Int(canvas.height * 1.5)
        ].shuffled()
        
        let randomLocation = CGSize(width: Int.random(in: widthRange[0]),
                                    height: Int.random(in: heightRange[0]))
        return randomLocation
    }
     */
    
    // MARK: - Drawing Constraints
    private let deckSize: CGFloat = 80
    private let cardScaleEffectMax: CGFloat = 1.05
    private let padding: CGFloat = 10
    private let itemSpacing: CGFloat = 20
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView(game: ClassicSetGame(cards: GeometricCard.generateAll()))

            // iPhone 11 Pro Max landscape size
            ContentView(game: ClassicSetGame(cards: GeometricCard.generateAll()))
                .previewLayout(.fixed(width: 896, height: 414))
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}


