//
//  MenuItem.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import Cocoa

final class MenuItem: NSMenuItem {
    private let actionClosure: (() -> Void)?

    init(_ title: String, action: (() -> Void)? = nil) {
        self.actionClosure = action
        super.init(title: title, action: action != nil ? #selector(Self.invoke(_:)) : nil, keyEquivalent: "")

        if action != nil {
            self.target = self
            self.action = #selector(Self.invoke(_:))
        }
    }

    required init(coder: NSCoder) {
        fatalError("Not implement")
    }

    @objc
    func invoke(_ sender: Any) {
        actionClosure?()
    }

    func keyEquivalent(_ keyEquivalent: String, with modifierMask: NSEvent.ModifierFlags? = nil) -> Self {
        self.keyEquivalent = keyEquivalent
        if let modifierMask {
            self.keyEquivalentModifierMask = modifierMask
        }
        return self
    }

    deinit {
        print("deinit MenuItem")
    }
}

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
