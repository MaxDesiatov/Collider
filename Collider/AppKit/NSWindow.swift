//
//  NSWindow.swift
//  Collider
//
//  Created by Max Desiatov on 31/12/2020.
//

import AppKit
import SwiftUI

extension NSWindow {
  convenience init<V: View>(view: V, autosave: String, delegate: NSWindowDelegate) {
    self.init(
      contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
      styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
      backing: .buffered,
      defer: false
    )
    self.delegate = delegate
    self.isReleasedWhenClosed = false
    self.center()
    self.setFrameAutosaveName("WelcomeWindow")
    self.contentView = NSHostingView(rootView: view)
    self.makeKeyAndOrderFront(nil)
  }
}
