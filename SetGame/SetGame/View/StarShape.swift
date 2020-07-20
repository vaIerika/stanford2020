//
//  StarShape.swift
//  SetGame
//
//  Created by Valerie 👩🏼‍💻 on 14/07/2020.
//

import SwiftUI

struct Star: Shape {
    let corners: Int
    let smoothness: CGFloat
    
    func path(in rect: CGRect) -> Path {
        guard corners >= 2 else { return Path() }
        
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        
        // modify drawing in the more natural way, otherwise it will be flipped
        var currentAngle = -CGFloat.pi / 2
        
        // how much to move with each star corner
        let angleAdjustment = .pi * 2 / CGFloat(corners * 2)
        
        // how much to move X/Y for the inner points of the star
        let innerX = center.x * smoothness
        let innerY = center.y * smoothness
        
        var path = Path()
        
        path.move(to: CGPoint(x: center.x * cos(currentAngle), y: center.y * sin(currentAngle)))
        
        // track the lowest point to place star in the center later
        var bottomEdge: CGFloat = 0
        
        for corner in 0..<(corners * 2) {
            let sinAngle = sin(currentAngle)
            let cosAngle = cos(currentAngle)
            let bottom: CGFloat
            
            if corner.isMultiple(of: 2) {
                
                // draw the outer edge of the star
                bottom = center.y * sinAngle
                path.addLine(to: CGPoint(x: center.x * cosAngle, y: bottom))
            } else {
                
                // draw an inner point
                bottom = innerY * sinAngle
                path.addLine(to: CGPoint(x: innerX * cosAngle, y: bottom))
            }
            
            
            
            // update the lowest point
            if bottom > bottomEdge {
                bottomEdge = bottom
            }
            
            // move on to the next corner
            currentAngle += angleAdjustment
        }
        path.closeSubpath()
        
        // how much unused space is at the bottom of the drawing rect
        let unusedSpace = (rect.height / 2 - bottomEdge) / 2
        
        // centering the shape vertically
        let transform = CGAffineTransform(translationX: center.x, y: center.y + unusedSpace)
        return path.applying(transform)
    }
}


struct StarShape_Previews: PreviewProvider {
    static var previews: some View {
        Star(corners: 5, smoothness: 0.65)
            .frame(width: 100)
            .aspectRatio(1, contentMode: .fit)
            .foregroundColor(.blue)
    }
}
