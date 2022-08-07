//
//  CaffeinatorStatusMenuItem.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import Cocoa
import Combine

public final class CaffeinatorStatusMenuItem: NSMenuItem {
    private let viewModel: CaffeinatorStatusMenuItemViewModel
    private var cancellables = Set<AnyCancellable>()

    public init(environment: CaffeinatorStatusMenuItemEnvironment) {
        self.viewModel = .init(interactor: .init(environment: environment))
        super.init(title: "Enable Caffeinator", action: #selector(Self.invoke), keyEquivalent: "")
        self.target = self

        viewModel.$isEnabled
            .sink { [weak self] isEnabled in
                self?.state = isEnabled ? .on : .off
            }
            .store(in: &cancellables)
    }

    @objc
    func invoke() {
        viewModel.isEnabled = !(state == .on)
    }

    public required init(coder: NSCoder) {
        fatalError("Not implement")
    }
}
