//
//  SideBarView.swift
//  CocoaToys
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import Cocoa
import SwiftUI
import UIComponents

protocol ContentView: View {
    init(environment: AppEnvironment)
}

struct SideBarView: View {

    private let environment: AppEnvironment

    @Binding var selectedCategory: MainContentViewCategory

    init(environment: AppEnvironment, selectedCategory: Binding<MainContentViewCategory>) {
        self.environment = environment
        self._selectedCategory = selectedCategory
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    item(.caffeinator)
                }
            }
        }
    }

    private func item(_ type: MainContentViewCategory) -> some View {
        Button {
            selectedCategory = type
        } label: {
            Text(type.title)
                .foregroundColor(
                    type == selectedCategory
                    ? .cocoaToys.selectedForeground
                    : .cocoaToys.foreground
                )
                .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 0))
            Spacer()
        }
        .buttonStyle(.plain)
        .frame(height: 44)
        .background(
            type == selectedCategory
            ? Color.cocoaToys.accent
            : Color.cocoaToys.background
        )
        .cornerRadius(4)
    }
}

#if DEBUG
struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(
            environment: MockEnvironment(),
            selectedCategory: .constant(.caffeinator)
        )
        .previewLayout(.fixed(width: 250, height: 500))
    }
}
#endif
