//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture

enum EditorSlot: Equatable {
  case editor(EditorState)
  case horizontal([EditorSlot])
  case vertical([EditorSlot])

  init(_ fileItem: FileItem?) {
    // FIXME: check if `fileItem` is a directory
    self = .editor(.init(tabs: .init([.init(fileItem)])))
  }
}

struct WorkspaceState: Equatable {
  typealias ID = UUID
  var root: FileItem?
  var selectedItem: FileItem?

  // FIXME: Use `TextStorage` instead
  var editedText = ""

  var slots: EditorSlot
}

enum WorkspaceAction {
  case select(FileItem?)
}

typealias WorkspaceStore = Store<WorkspaceState, WorkspaceAction>
typealias WorkspaceReducer =
  Reducer<WorkspaceState, WorkspaceAction, SystemEnvironment<WorkspaceEnvironment>>

let workspaceReducer = WorkspaceReducer { state, action, _ in
  switch action {
  case let .select(item):
    state.selectedItem = item
    if let item = item, item.children == nil {
      state.editedText = try! String(contentsOf: URL(fileURLWithPath: item.path.description))
    }
    return .none
  }
}
