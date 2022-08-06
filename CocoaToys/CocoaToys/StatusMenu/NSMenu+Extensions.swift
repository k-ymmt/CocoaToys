//
//  NSMenu+Extensions.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import Cocoa

@resultBuilder
enum MenuItemBuilder {
    static func buildBlock(_ components: NSMenuItem...) -> [NSMenuItem] {
        components
    }

    static func buildEither(first component: [NSMenuItem]) -> [NSMenuItem] {
        component
    }

    static func buildEither(second component: [NSMenuItem]) -> [NSMenuItem] {
        component
    }

    static func buildExpression(_ expression: NSMenuItem) -> NSMenuItem {
        expression
    }

    static func buildExpression(_ expression: NSMenuItemConvertible) -> NSMenuItem {
        expression.menuItem()
    }
}

extension NSMenu {
    func addItems(@MenuItemBuilder builder: () -> [NSMenuItem]) {
        items = builder()
    }
}
