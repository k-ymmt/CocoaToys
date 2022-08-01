//
//  Text+Style.swift
//  UIComponents
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import SwiftUI

public struct TextStyle {
    let foregroundColor: Color
    let fontSize: CGFloat
    let weight: Font.Weight
}

public extension TextStyle {
    static var head: TextStyle {
        TextStyle(foregroundColor: .cocoaToys.foreground, fontSize: 15, weight: .bold)
    }
}

public struct TextStyleModifier: ViewModifier {
    private let style: TextStyle

    init(style: TextStyle) {
        self.style = style
    }

    public func body(content: Content) -> some View {
        content
            .font(.system(size: style.fontSize, weight: style.weight))
            .foregroundColor(style.foregroundColor)
    }
}

public extension Text {
    func textStyle(_ style: TextStyle) -> ModifiedContent<Text, TextStyleModifier> {
        modifier(TextStyleModifier(style: style))
    }
}
