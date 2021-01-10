//
//  EditorTabState.swift
//  Collider
//
//  Created by Max Desiatov on 10/01/2021.
//

import Foundation
import System

struct EditorTabState: Identifiable, Equatable {
  let id: UUID
  var path: FilePath?
  let storage: TextStorage
  var isUnsaved: Bool
}

extension EditorTabState {
  init(_ fileItem: FileItem?) {
    self.init(id: .init(), path: fileItem?.path, storage: .init(), isUnsaved: fileItem == nil)
  }
}
