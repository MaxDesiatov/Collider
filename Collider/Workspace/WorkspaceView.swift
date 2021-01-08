//
//  Created by Max Desiatov on 28/12/2020.
//

import ComposableArchitecture
import Sourceful
import SwiftUI
import System

struct WorkspaceView: View {
  init(_ store: WorkspaceStore) {
    self.store = store
  }

  private let store: WorkspaceStore

  var body: some View {
    WithViewStore(store) { viewStore in
      if let root = viewStore.root {
        NavigationView {
          List(
            [root],
            children: \.children,
            selection: viewStore.binding(get: \.selectedItem, send: WorkspaceAction.select)
          ) { item in
            HStack {
              Text(item.description)
              Spacer()
            }
            .padding(2)
          }
          .listStyle(SidebarListStyle())
          .frame(minWidth: 220)

          SourceCodeTextEditor(text: viewStore.binding(get: \.editedText, send: WorkspaceAction.edit))
        }
      } else {
        WelcomeView()
      }
    }
  }
}
