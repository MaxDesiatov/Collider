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
  private let index: Int

  init<V: View>(
    _ viewStore: RootViewStore,
    index: Int,
    view: V,
    delegate: NSWindowDelegate
  ) {
    self.viewStore = viewStore
    self.index = index
    super.init(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false
    )
    self.delegate = delegate
    self.isReleasedWhenClosed = false
    self.center()
    self.setFrameAutosaveName("ColliderWindow\(index)")
    self.contentView = NSHostingView(rootView: view)
    self.makeKeyAndOrderFront(nil)
  }

  @objc func openDocument(_ sender: Any?) {
    viewStore.send(.showOpenDialog(workspaceIndex: index))
  }
}
