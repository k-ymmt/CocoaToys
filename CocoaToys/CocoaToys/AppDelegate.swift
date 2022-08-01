//
//  AppDelegate.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/07/28.
//

import Foundation
import AppKit
import SwiftUI

@main
final class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.disableRelaunchOnLogin()

        let window = NSWindow(
            contentRect: .zero,
            styleMask: [
                .titled,
                .closable,
                .miniaturizable,
                .resizable,
                .fullSizeContentView
            ],
            backing: .buffered,
            defer: false
        )

        window.contentView = NSHostingView(rootView: MainView(environment: CocoaToysEnvironment()))
        window.title = "CocoaToys"
        window.minSize = .init(width: 500, height: 350)
        window.center()
        window.makeKeyAndOrderFront(self)
        self.window = window

        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationWillTerminate(_ notification: Notification) {
        print("Terminated.")
    }
}
