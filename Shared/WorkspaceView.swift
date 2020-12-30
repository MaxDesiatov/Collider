//
//  Created by Max Desiatov on 28/12/2020.
//

import ComposableArchitecture
import Sourceful
import SwiftUI

struct WorkspaceView: View {
  init(_ store: WorkspaceStore) {
    self.store = store
  }

  private let store: WorkspaceStore

  @State var text = ""
  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        ScrollView {
          OutlineGroup(viewStore.root, children: \.children) {
            Text($0.description)
          }
          .padding()
        }
        SourceCodeTextEditor(text: $text)
      }
    }
  }
}
