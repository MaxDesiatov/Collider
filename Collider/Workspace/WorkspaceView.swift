//
//  Created by Max Desiatov on 28/12/2020.
//

import ComposableArchitecture
import SwiftUI
import System

struct WorkspaceView: View {
  init(_ store: WorkspaceStore) {
    self.store = store
  }

  private let store: WorkspaceStore

  var body: some View {
    WithViewStore(store) { _ in
      NavigationView {
        NavigationTabView(store: store.navigationTab)

        EditorView()
      }
    }
  }
}
