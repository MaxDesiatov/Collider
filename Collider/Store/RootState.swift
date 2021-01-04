//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture
import System

struct RootState: Equatable {
  var workspaces = [WorkspaceState]()
}

enum RootAction {
  case showOpenDialog(workspaceIndex: Int?)
  case openWorkspace(FilePath?, isPersistent: Bool, workspaceIndex: Int?)
  case openDialogResponse(Result<URL?, Never>, workspaceIndex: Int?)
  case traversalResponse(Result<FileItem, Error>, workspaceIndex: Int?)
  case workspace(Int, WorkspaceAction)
  case removeWorkspace(Int)
}

extension Store {
  typealias ViewStore = ComposableArchitecture.ViewStore<State, Action>
}

typealias RootStore = Store<RootState, RootAction>
typealias RootViewStore = RootStore.ViewStore

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
    case let .showOpenDialog(workspaceIndex):
      return environment.showOpenDialog()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map { RootAction.openDialogResponse($0, workspaceIndex: workspaceIndex) }

    case let .openWorkspace(path, isPersistent, workspaceIndex):
      environment.openWorkspace(path, isPersistent)

      guard let path = path else {
        state.workspaces.append(.init())
        return .none
      }
      return environment.traverse(URL(fileURLWithPath: path.description))
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map { RootAction.traversalResponse($0, workspaceIndex: workspaceIndex) }

    case let .openDialogResponse(.success(url?), workspaceIndex):
      return environment.traverse(url)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map { RootAction.traversalResponse($0, workspaceIndex: workspaceIndex) }

    case let .traversalResponse(.success(fileItem), workspaceIndex):
      state.workspaces.append(.init(root: fileItem))
      return .none

    case let .traversalResponse(.failure(error), workspaceIndex):
      environment.showAlert(error)
      return .none

    case .openDialogResponse(.success(nil), _):
      return .none

    case let .removeWorkspace(index):
      state.workspaces.remove(at: index)
      environment.removeWorkspace(index)
      return .none
    }
  }
)
