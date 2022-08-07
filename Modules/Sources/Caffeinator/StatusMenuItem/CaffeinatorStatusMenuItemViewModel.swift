//
//  CaffeinatorStatusMenuItemViewModel.swift
//  
//
//  Created by Kazuki Yamamoto on 2022/08/06.
//

import Foundation
import Combine

final class CaffeinatorStatusMenuItemViewModel {
    @Published var isEnabled: Bool = false

    private let interactor: CaffeinatorStatusMenuItemInteractor
    private var cancellables = Set<AnyCancellable>()

    init(interactor: CaffeinatorStatusMenuItemInteractor) {
        self.interactor = interactor
        interactor.$isEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: &$isEnabled)

        $isEnabled
            .dropFirst(2)
            .removeDuplicates()
            .sink { isEnabled in
                interactor.saveIsEnabled(isEnabled)
            }
            .store(in: &cancellables)
    }
}
