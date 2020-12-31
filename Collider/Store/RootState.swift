//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture

struct RootState: Equatable {
  var workspaces = [WorkspaceState]()
}

enum RootAction {
  case open
  case openResponse(Result<FileItem?, Never>)
  case workspace(Int, WorkspaceAction)
}

typealias RootStore = Store<RootState, RootAction>

extension RootStore {
  func workspace(_ index: Int) -> WorkspaceStore {
    scope(state: { $0.workspaces[index] }, action: { RootAction.workspace(index, $0) })
  }
}

typealias RootReducer = Reducer<RootState, RootAction, SystemEnvironment<RootEnvironment>>

let rootReducer = RootReducer.combine(
  workspaceReducer.forEach(
    state: \.workspaces,
    action: /RootAction.workspace,
    environment: { .live($0.workspace) }
  ),
  .init { state, action, environment in
    switch action {
    case .open:
      return environment.open()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(RootAction.openResponse)

    case let .openResponse(.success(fileItem?)):
      state.workspaces.append(.init(root: fileItem))
      return .none

    case .openResponse(.success(nil)):
      return .none
    }
  }
)
