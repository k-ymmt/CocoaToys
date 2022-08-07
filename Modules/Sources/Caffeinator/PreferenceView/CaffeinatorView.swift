//
//  CaffeinatorView.swift
//  Caffeinator
//
//  Created by Kazuki Yamamoto on 2022/07/30.
//

import Foundation
import SwiftUI
import UIComponents

public struct CaffeinatorView: View {
    @ObservedObject var viewModel: CaffeinatorViewModel

    public init(environment: CaffeinatorEnvironment) {
        self.viewModel = .init(
            interactor: .init(
                dependency: .init(
                    configManager: environment.configManager,
                    service: environment.caffeinatorService
                )
            )
        )
    }

    public var body: some View {
        List {
            Section {
                Toggle(isOn: $viewModel.caffeinatorEnabled) {
                    Text("Enable Caffeinator")
                        .textStyle(.head)
                    Spacer()
                }
                .toggleStyle(.switch)
                .accentColor(.cocoaToys.accent)
            }

            Section {
                HStack(alignment: .top) {
                    Text("Sleep Type")
                        .font(.system(size: 15))
                    Spacer()
                    Picker("", selection: $viewModel.sleepType) {
                        ForEach(CaffeinatorNoSleepType.allCases) { type in
                            Text(type.title).tag(type)
                                .frame(height: 30)
                        }
                    }
                    .disabled(!viewModel.caffeinatorEnabled)
                    .pickerStyle(.radioGroup)
                    .accentColor(.cocoaToys.accent)
                }
            } header: {
                Text("Options")
            }
        }
    }
}

private extension CaffeinatorNoSleepType {
    var title: String {
        switch self {
        case .noDisplaySleep:
            return "Display and System"
        case .noIdleSleep:
            return "System(display may sleep)"
        }
    }
}

#if DEBUG
struct CaffeinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CaffeinatorView(environment: MockEnvironment())
    }
}
#endif
