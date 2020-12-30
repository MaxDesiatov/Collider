//
//  ContentView.swift
//  Shared
//
//  Created by Max Desiatov on 28/12/2020.
//

import Sourceful
import SwiftUI

struct ContentView: View {
    @State var text: String = ""
    var body: some View {
        SourceCodeTextEditor(text: $text)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
