//
//  EditorState.swift
//  Collider
//
//  Created by Max Desiatov on 10/01/2021.
//

import ComposableArchitecture
import SwiftLSPClient

struct EditorState: Equatable {
  let tabs: IdentifiedArrayOf<EditorTabState>
  var currentTab = 0
}

enum EditorAction {
  case save
  case hover(Position)
  case closeTab(EditorTabState.ID)
}
