//
//  WindowManager.swift
//  Collider
//
//  Created by Max Desiatov on 31/12/2020.
//

import AppKit
import ComposableArchitecture
import System

final class WindowManager: NSObject, NSWindowDelegate {
  private var windows = [NSWindow]()

  private let store = Store(
    initialState: RootState(),
    reducer: rootReducer,
    environment: RootEnvironment.live
  )

  private lazy var viewStore = ViewStore(store)

  func showWelcomeWindow() {
    viewStore.send(.openEmptyWorkspace)
    windows.append(.init(view: WelcomeView(), autosave: "WelcomeView", delegate: self))
  }

  func showWorkspaceWindows(_ paths: [FilePath?]) {
    for (index, path) in paths.enumerated() {
      guard let path = path else {
        showWelcomeWindow()
        continue
      }
      viewStore.send(.openWorkspace(path))
      windows.append(
        .init(
          view: WorkspaceView(store.workspace(index)),
          autosave: path.description,
          delegate: self
        )
      )
    }
  }

  func windowShouldClose(_ sender: NSWindow) -> Bool {
    guard let index = windows.firstIndex(of: sender) else { return true }

    viewStore.send(.removeWorkspace(index))

    return true
  }
}
