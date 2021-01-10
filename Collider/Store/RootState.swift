//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture
import System

struct RootState: Equatable {
  var workspaces = [WorkspaceState.ID: WorkspaceState]()
}

enum RootAction {
  case launch([WorkspaceState.ID: String])
  case showOpenDialog(workspaceID: WorkspaceState.ID?)
  case openWorkspace(FileItem?, isPersistent: Bool, workspaceID: WorkspaceState.ID?)
  case openDialogResponse(Result<URL?, Never>, workspaceID: WorkspaceState.ID?)
  case traversalResponse(Result<FileItem, Error>, WorkspaceState.ID)
  case workspace(WorkspaceState.ID, WorkspaceAction)
  case removeWorkspace(WorkspaceState.ID)
}

extension Store {
  typealias ViewStore = ComposableArchitecture.ViewStore<State, Action>
}

typealias RootStore = Store<RootState, RootAction>
typealias RootViewStore = RootStore.ViewStore

extension RootStore {
  func workspace(_ id: WorkspaceState.ID) -> Store<WorkspaceState?, WorkspaceAction> {
    scope(state: { $0.workspaces[id] }, action: { RootAction.workspace(id, $0) })
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
    case let .launch(paths):
      guard !paths.isEmpty else {
        return .init(value: .openWorkspace(nil, isPersistent: true, workspaceID: nil))
      }

      return .init(paths.map { (id, path) -> RootAction in
        guard !path.isEmpty else {
          return .openWorkspace(nil, isPersistent: false, workspaceID: id)
        }
        return .openWorkspace(FileItem(path: FilePath(path)), isPersistent: false, workspaceID: id)
      }
      .publisher)

    case let .showOpenDialog(workspaceID):
      return environment.showOpenDialog()
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map { RootAction.openDialogResponse($0, workspaceID: workspaceID) }

    case let .openWorkspace(fileItem, isPersistent, workspaceID):
      let workspaceID = workspaceID ?? .init()
      state.workspaces[workspaceID] = .init(root: fileItem)
      defer {
        environment.openWorkspace(fileItem?.path, isPersistent, workspaceID)
      }

      guard let fileItem = fileItem else { return .none }

      return environment.traverse(fileItem.path)
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map { RootAction.traversalResponse($0, workspaceID) }

    case let .openDialogResponse(.success(url?), workspaceID):
      return environment.traverse(FilePath(url.path))
        .receive(on: environment.mainQueue)
        .catchToEffect()
        .map { RootAction.traversalResponse($0, workspaceID ?? .init()) }

    case let .traversalResponse(.success(fileItem), workspaceID):
      state.workspaces[workspaceID] = .init(root: fileItem)
      environment.openWorkspace(fileItem.path, true, workspaceID)
      return .none

    case let .traversalResponse(.failure(error), workspaceID):
      environment.showAlert(error)
      return .none

    case .openDialogResponse(.success(nil), _):
      return .none

    case let .removeWorkspace(id):
      state.workspaces[id] = nil
      environment.removeWorkspace(id)
      return .none

    case .workspace:
      // handled by `workspaceReducer`
      return .none
    }
  }
)
