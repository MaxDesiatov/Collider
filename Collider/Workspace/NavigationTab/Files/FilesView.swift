//
//  FilesView.swift
//  Collider
//
//  Created by Max Desiatov on 10/01/2021.
//

import ComposableArchitecture
import SwiftUI

struct FilesView: View {
  let store: FilesStore

  var body: some View {
    WithViewStore(store) { viewStore in
      if let root = viewStore.root {
        List(
          [root],
          children: \.children,
          selection: viewStore.binding(get: \.selection, send: FilesAction.select)
        ) { item in
          HStack {
            Text(item.description)
            Spacer()
          }
          .padding(2)
          .contextMenu {
            Button("Rename") { print("rename") }
          }
        }
        .listStyle(SidebarListStyle())
        .frame(minWidth: 250)
      }
    }
  }
}
