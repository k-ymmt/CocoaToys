//
//  MainContentViewType.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import Caffeinator

enum MainContentViewCategory: String {
    case caffeinator = "Caffeinator"

    var title: String {
        rawValue
    }

    func view(environment: AppEnvironment) -> any ContentView {
        switch self {
        case .caffeinator:
            return CaffeinatorView(environment: environment)
        }
    }
}

extension CaffeinatorView: ContentView {
    init(environment: AppEnvironment) {
        self.init(environment: environment as CaffeinatorEnvironment)
    }
}
