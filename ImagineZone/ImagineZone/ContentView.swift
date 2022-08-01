//
//  ContentView.swift
//  ImagineZone
//
//  Created by Kazuki Yamamoto on 2022/07/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello World!!")
            Button("Control Windows") {
                bar()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
