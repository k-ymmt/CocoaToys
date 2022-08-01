//
//  MainView.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/07/29.
//

import Foundation
import SwiftUI

struct MainView: View {
    private let environment: AppEnvironment
    init(environment: AppEnvironment) {
        self.environment = environment
    }

    @State var selectedCategory: MainContentViewCategory = .caffeinator

    var body: some View {
        HStack {
            SideBarView(environment: environment, selectedCategory: $selectedCategory)
                .frame(width: 220)
            Divider()
            VStack {
                content(selectedCategory)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
    }

    private func content(_ category: MainContentViewCategory) -> AnyView {
        AnyView(category.view(environment: environment))
    }
}
