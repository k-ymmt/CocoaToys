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
        interactor.$enabled
            .receive(on: DispatchQueue.main)
            .assign(to: &$caffeinatorEnabled)
        interactor.$noSleepType
            .map(CaffeinatorNoSleepType.init)
            .receive(on: DispatchQueue.main)
            .assign(to: &$sleepType)

        $caffeinatorEnabled
            .dropFirst(2)
            .removeDuplicates()
            .assign(to: &interactor.$enabled)
        $sleepType
            .dropFirst(2)
            .removeDuplicates()
            .map(CaffeinatorConfig.NoSleepType.init)
            .assign(to: &interactor.$noSleepType)
    }
}

private extension CaffeinatorNoSleepType {
    init(_ type: CaffeinatorConfig.NoSleepType) {
        switch type {
        case .display:
            self = .noDisplaySleep
        case .idle:
            self = .noIdleSleep
        }
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
