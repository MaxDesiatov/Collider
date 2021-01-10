//
//  NavigationTabView.swift
//  Collider
//
//  Created by Max Desiatov on 10/01/2021.
//

import ComposableArchitecture
import SwiftUI

private struct NavigationTabIcon: View {
  let systemName: String

  var body: some View {
    Image(systemName: systemName)
      .resizable()
      .aspectRatio(contentMode: .fit)
      .padding(5)
      .frame(maxWidth: 44)
  }
}

struct NavigationTabView: View {
  let store: NavigationTabStore

  var body: some View {
    HStack(alignment: .top) {
      VStack {
        NavigationTabIcon(systemName: "folder")

        NavigationTabIcon(systemName: "magnifyingglass")
      }.padding(5)

      Rectangle()
        .background(Color.gray)
        .frame(minWidth: 2, maxWidth: 2, maxHeight: .infinity)

      FilesView(store: store.files)
    }
  }
}
