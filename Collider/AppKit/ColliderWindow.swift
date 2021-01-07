//
//  NSWindow.swift
//  Collider
//
//  Created by Max Desiatov on 31/12/2020.
//

import AppKit
import SwiftUI

final class ColliderWindow: NSWindow {
  private let viewStore: RootViewStore
  let workspaceID: WorkspaceState.ID

  init<V: View>(
    _ viewStore: RootViewStore,
    _ workspaceID: WorkspaceState.ID,
    view: V,
    delegate: NSWindowDelegate
  ) {
    self.viewStore = viewStore
    self.workspaceID = workspaceID
    super.init(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false
    )
    self.delegate = delegate
    self.isReleasedWhenClosed = false
    self.center()
    self.setFrameAutosaveName(workspaceID.description)
    self.contentView = NSHostingView(rootView: view)
    self.makeKeyAndOrderFront(nil)
  }

  func openDocument() {
    viewStore.send(.showOpenDialog(workspaceID: workspaceID))
  }
}
