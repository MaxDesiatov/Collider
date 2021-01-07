//
//  Created by Max Desiatov on 30/12/2020.
//

import ComposableArchitecture
import System

struct FileItem: Hashable, Identifiable, CustomStringConvertible {
  init(name: String? = nil, path: FilePath, children: [FileItem]? = nil) {
    self.name = name ?? URL(fileURLWithPath: path.description).lastPathComponent
    self.path = path
    self.children = children
  }

  var id: Self { self }
  var name: String
  var path: FilePath
  var children: [FileItem]? = nil

  var description: String {
    switch children {
    case nil:
      return "📄 \(name)"
    case let .some(children):
      return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
    }
  }
}

struct WorkspaceState: Equatable {
  typealias ID = UUID
  var root: FileItem?
}

enum WorkspaceAction {

}

typealias WorkspaceStore = Store<WorkspaceState, WorkspaceAction>
typealias WorkspaceReducer =
  Reducer<WorkspaceState, WorkspaceAction, SystemEnvironment<WorkspaceEnvironment>>

let workspaceReducer = WorkspaceReducer  { _, _, _ in .none }
