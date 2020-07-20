//
//  FigureBuilderView.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 20/07/2020.
//

import SwiftUI

struct FigureBuilderView: View {
    var card: GeometricCard

    struct FigureShapeView: Shape {
        var figure: GeometricCard.Figure
        
        func path(in rect: CGRect) -> Path {
            switch figure {
            case .circle: return Circle().path(in: rect)
            case .diamond: return Diamond().path(in: rect)
            case .star: return Star(corners: 5, smoothness: 0.65).path(in: rect)
            }
        }
    }
    
    private var color: Color {
        if card.color == .yellow {
            return .yellow
        } else if card.color == .blue {
            return .blue
        } else {
            return .red
        }
    }
    
    private var figure: FigureShapeView {
        return FigureShapeView(figure: card.figure)
    }
    
    var body: some View {
        ZStack {
            Color(.red).opacity(0)
            
            VStack(spacing: 10) {
                ForEach(0..<card.number.rawValue, id: \.self) { _ in
                    figure
                        .frame(minWidth: 12, minHeight: 12)
                        .shading(card.shading)
                        .overlay(
                            figure.stroke(lineWidth: 3)
                        )
                        .foregroundColor(color)
                        .aspectRatio(1, contentMode: .fit)
                }
            }
            .padding(10)
        }
        .padding(.horizontal, 10)
    }
}

struct FigureBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        FigureBuilderView(card: GeometricCard(number: .three, color: .blue, shading: .solid, figure: .diamond))
            .frame(width: 200, height: 200)
    }
}
