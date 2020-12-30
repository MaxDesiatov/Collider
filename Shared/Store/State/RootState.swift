//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture

struct RootState: Equatable {
  var workspace: WorkspaceState?
}

enum RootAction {
  case open
  case openResponse(Result<FileItem?, Never>)
  case workspace(WorkspaceAction)
}

typealias RootStore = Store<RootState, RootAction>
typealias RootReducer = Reducer<RootState, RootAction, SystemEnvironment<RootEnvironment>>

extension RootStore {
  var workspace: Store<WorkspaceState?, WorkspaceAction> {
    scope(state: \.workspace, action: RootAction.workspace)
  }
}

let rootReducer = RootReducer { state, action, environment in
  switch action {
  case .open:
    return environment.open()
      .receive(on: environment.mainQueue)
      .catchToEffect()
      .map(RootAction.openResponse)

  case let .openResponse(.success(fileItem?)):
    state.workspace = WorkspaceState(root: fileItem)
    return .none

  case .openResponse(.success(nil)):
    return .none
  }
}
