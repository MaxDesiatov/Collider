//
//  Created by Max Desiatov on 10/01/2021.
//

import ComposableArchitecture

struct FilesState: Equatable {
  var root: FileItem?
  var selection: FileItem?
}

enum FilesAction {
  case select(FileItem?)
}

typealias FilesStore = Store<FilesState, FilesAction>
typealias FilesReducer = Reducer<FilesState, FilesAction, SystemEnvironment<FilesEnvironment>>

let filesReducer = FilesReducer { state, action, _ in
  switch action {
  case let .select(item):
    state.selection = item
    return .none
  }
}
