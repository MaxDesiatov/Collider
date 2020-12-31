//
//  Created by Max Desiatov on 28/12/2020.
//

import ComposableArchitecture
import SwiftUI

@main
struct ColliderApp: App {
  private let store = Store(
    initialState: RootState(),
    reducer: rootReducer,
    environment: .live(rootEnvironment)
  )

  var body: some Scene {
    SceneWithViewStore(store) { viewStore in
      WindowGroup {
        IfLetStore(store.workspace, then: WorkspaceView.init, else: WelcomeView())
      }.commands {
        CommandGroup(after: CommandGroupPlacement.newItem) {
          Button("Open...") {
            viewStore.send(.open)
          }.keyboardShortcut("o", modifiers: [.command])
        }
      }
    }
  }
}
