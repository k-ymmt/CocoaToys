//
//  CocoaToysStatusBarMenu.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import Cocoa
import SwiftUI
import Caffeinator

final class CocoaToysStatusBarMenu: NSMenu {
    private let environment: AppEnvironment
    private var preferecesWindow: NSWindowController?

    init(environment: AppEnvironment) {
        self.environment = environment
        super.init(title: "CocoaToys")

        self.addItems {
            MenuItem("Caffeinator")
            CaffeinatorStatusMenuItem(environment: environment)

            NSMenuItem.Separator()

            MenuItem("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "unknown")")
            MenuItem("Preferences...") { [weak self] in
                self?.openPreferences()
            }

            NSMenuItem.Separator()

            MenuItem("Quit") { [weak self] in
                self?.terminate()
            }
        }
    }

    required init(coder: NSCoder) {
        fatalError("Not implement")
    }
}

extension CocoaToysStatusBarMenu: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
    }
}

private extension CocoaToysStatusBarMenu {
    func openPreferences() {
        if preferecesWindow == nil {
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
            window.contentView = NSHostingView(rootView: MainView(environment: environment))
            window.title = "CocoaToys"
            window.minSize = .init(width: 500, height: 350)
            window.delegate = self
            self.preferecesWindow = NSWindowController(window: window)
        }

        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        preferecesWindow?.showWindow(self)
    }

    func terminate() {
        NSApp.terminate(self)
    }

    func openAbout() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(self)
    }
}
