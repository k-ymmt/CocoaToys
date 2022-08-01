//
//  Color+CocoaToys.swift
//  UIComponents
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import SwiftUI

public extension Color {
    final class CocoaToys {
        public static var background: Color {
            color("Background")
        }
        public static var foreground: Color {
            color("Foreground")
        }
        public static var accent: Color {
            color("Accent")
        }
        public static var selectedForeground: Color {
            color("SelectedForeground")
        }

        private static func color(_ name: String) -> Color {
            Color(name, bundle: .module)
        }

        private init() {
        }
    }

    static var cocoaToys: CocoaToys.Type {
        CocoaToys.self
    }
}
