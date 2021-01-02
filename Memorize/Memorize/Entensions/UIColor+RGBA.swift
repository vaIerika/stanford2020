//
//  UIColor+RGBA.swift
//  Memorize
//
//  Created by Valerie 👩🏼‍💻 on 10/08/2020.
//

import Foundation
import UIKit
import SwiftUI

// Assignment 5.
extension UIColor {
    
    public struct RGB: Hashable, Codable {
        var red: CGFloat
        var green: CGFloat
        var blue: CGFloat
        var alpha: CGFloat
    }
    
    convenience init(_ rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: rgb.alpha)
    }
    
    static func getRGB(_ uiColor: UIColor) -> UIColor.RGB {
    return RGB(red: uiColor.rgb.red, green: uiColor.rgb.green, blue: uiColor.rgb.blue, alpha: uiColor.rgb.alpha)
    }
    
    public var rgb: RGB {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGB(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension Color {
    init(_ rgb: UIColor.RGB) {
        self.init(UIColor(rgb))
    }
}

