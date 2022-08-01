//
//  CaffeinatorViewModel.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import SwiftUI
import Combine

enum CaffeinatorNoSleepType: Int, CaseIterable, Identifiable {
    case noDisplaySleep
    case noIdleSleep

    var id: Int {
        rawValue
    }
}

final class CaffeinatorViewModel: ObservableObject {
    @Published var caffeinatorEnabled: Bool = false
    @Published var sleepType: CaffeinatorNoSleepType = .noDisplaySleep

    private var cancellables = Set<AnyCancellable>()
    private var interactor: CaffeinatorInteractor

    init(interactor: CaffeinatorInteractor) {
        self.interactor = interactor
        interactor.enabled
            .receive(on: DispatchQueue.main)
            .assign(to: &$caffeinatorEnabled)

        Publishers.CombineLatest($caffeinatorEnabled, $sleepType)
            .dropFirst(2)
            .removeDuplicates(by: { previous, next in
                previous.0 == next.0 && previous.1 == next.1
            })
            .sink { (enabled, sleepType) in
                interactor.save(config: .init(enabled: enabled, noSleepType: .init(sleepType)))
            }.store(in: &cancellables)
    }
}

private extension CaffeinatorConfig.NoSleepType {
    init(_ type: CaffeinatorNoSleepType) {
        switch type {
        case .noDisplaySleep:
            self = .display
        case .noIdleSleep:
            self = .idle
        }
    }
}
