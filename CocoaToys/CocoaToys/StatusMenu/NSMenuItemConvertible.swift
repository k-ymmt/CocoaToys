//
//  NSMenuItemConvertible.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import Cocoa

protocol NSMenuItemConvertible {
    func menuItem() -> NSMenuItem
}

extension NSMenuItem {
    struct Separator: NSMenuItemConvertible {
        init() {
        }

        func menuItem() -> NSMenuItem {
            .separator()
        }
    }
}
