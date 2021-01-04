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
  private var windows = [ColliderWindow]()

  private lazy var store = Store(
    initialState: RootState(),
    reducer: rootReducer,
    environment: RootEnvironment.live(self)
  )

  private lazy var viewStore = ViewStore(store)

  func newWorkspace() {
    viewStore.send(.openWorkspace(nil, isPersistent: true, workspaceIndex: nil))
  }

  func showWelcomeWindow() {
    windows.append(
      .init(viewStore, index: windows.count, view: WelcomeView(), delegate: self)
    )
  }

  func showWorkspaceWindow(for workspaceIndex: Int) {
    if workspaceIndex < windows.count {
      windows[workspaceIndex].close()
      windows[workspaceIndex] = .init(
        viewStore,
        index: workspaceIndex,
        view: WorkspaceView(store.workspace(workspaceIndex)),
        delegate: self
      )
    } else {
      windows.append(
        .init(
          viewStore,
          index: workspaceIndex,
          view: WorkspaceView(store.workspace(workspaceIndex)),
          delegate: self
        )
      )
    }
  }

  func launch() {
    // FIXME: move this code to the reducer
    let paths = UserDefaults.standard.workspacePaths

    guard !paths.isEmpty else {
      return viewStore.send(.openWorkspace(nil, isPersistent: true, workspaceIndex: nil))
    }

    for path in paths {
      guard let path = path else {
        viewStore.send(.openWorkspace(nil, isPersistent: false, workspaceIndex: nil))
        continue
      }
      viewStore.send(.openWorkspace(path, isPersistent: false, workspaceIndex: nil))
    }
  }

  func windowShouldClose(_ sender: NSWindow) -> Bool {
    guard
      let window = sender as? ColliderWindow,
      let index = windows.firstIndex(of: window)
    else { return true }

    viewStore.send(.removeWorkspace(index))

    return true
  }
}
