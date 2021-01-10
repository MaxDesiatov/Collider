//
//  FileItem.swift
//  Collider
//
//  Created by Max Desiatov on 10/01/2021.
//

import Foundation
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
  var children: [FileItem]?

  var description: String {
    switch children {
    case nil:
      return "📄 \(name)"
    case let .some(children):
      return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
    }
  }
}
