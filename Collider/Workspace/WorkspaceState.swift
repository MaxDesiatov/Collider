//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture

enum EditorSlot: Equatable {
  case editor(EditorState)
  case horizontal([EditorSlot])
  case vertical([EditorSlot])

  init(_ fileItem: FileItem?) {
    self = .editor(.init(fileItem))
  }
}

struct WorkspaceState: Equatable {
  typealias ID = UUID

  var navigationTab: NavigationTabState
  var editors: EditorSlot

  init(root: FileItem?) {
    navigationTab = .init(root: root)
    editors = .init(root)
  }
}

enum WorkspaceAction {
  case navigationTab(NavigationTabAction)
  case select(FileItem?)
}

typealias WorkspaceStore = Store<WorkspaceState, WorkspaceAction>

extension WorkspaceStore {
  var navigationTab: NavigationTabStore {
    scope(state: \.navigationTab, action: WorkspaceAction.navigationTab)
  }
}

typealias WorkspaceReducer =
  Reducer<WorkspaceState, WorkspaceAction, SystemEnvironment<WorkspaceEnvironment>>

let workspaceReducer = WorkspaceReducer.combine()
