//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture
import System

struct RootState: Equatable {
  var workspaces = [WorkspaceState]()
}

enum RootAction {
  case openEmptyWorkspace
  case showOpenDialog
  case openWorkspace(FilePath)
  case openDialogResponse(Result<URL?, Never>)
  case traversalResponse(Result<FileItem, Error>)
  case workspace(Int, WorkspaceAction)
  case removeWorkspace(Int)
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
    case .openEmptyWorkspace:
      state.workspaces.append(.init())
      environment.addWorkspace(nil)
      return .none

    case .showOpenDialog:
      return environment.open()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(RootAction.openDialogResponse)

    case let .openWorkspace(path):
      return environment.traverse(URL(fileURLWithPath: path.description))
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(RootAction.traversalResponse)

    case let .openDialogResponse(.success(url?)):
      return environment.traverse(url)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map(RootAction.traversalResponse)

    case let .traversalResponse(.success(fileItem)):
      state.workspaces.append(.init(root: fileItem))
      environment.addWorkspace(fileItem.path)
      return .none

    case let .traversalResponse(.failure(error)):
      environment.showAlert(error)
      return .none

    case .openDialogResponse(.success(nil)):
      return .none

    case let .removeWorkspace(index):
      environment.removeWorkspace(index)
      return .none
    }
  }
)
