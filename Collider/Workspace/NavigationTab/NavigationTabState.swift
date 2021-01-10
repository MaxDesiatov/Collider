//
//  Created by Max Desiatov on 10/01/2021.
//

import ComposableArchitecture

struct NavigationTabState: Equatable {
  var files: FilesState

  init(root: FileItem?) {
    files = .init(root: root)
  }
}

enum NavigationTabAction {
  case files(FilesAction)
}

typealias NavigationTabStore = Store<NavigationTabState, NavigationTabAction>

extension NavigationTabStore {
  var files: FilesStore {
    scope(state: \.files, action: NavigationTabAction.files)
  }
}

typealias NavigationTabReducer =
  Reducer<NavigationTabState, NavigationTabAction, SystemEnvironment<NavigationTabEnvironment>>


let navigationTabReducer = NavigationTabReducer.combine(
  filesReducer.pullback(
    state: \.files,
    action: /NavigationTabAction.files,
    environment: { $0.map(\.files) }
  )
)
