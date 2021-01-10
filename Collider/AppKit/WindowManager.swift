//
//  WindowManager.swift
//  Collider
//
//  Created by Max Desiatov on 31/12/2020.
//

import AppKit
import Combine
import ComposableArchitecture
import System

final class WindowManager: NSObject, NSWindowDelegate {
  private var windows = [WorkspaceState.ID: ColliderWindow]()

  /// Used for finding workspace ID for a given window when reacting to a UI event.
  private var ids = [ColliderWindow: WorkspaceState.ID]()

  private lazy var store = Store(
    initialState: RootState(),
    reducer: rootReducer,
    environment: RootEnvironment.live(self)
  )

  private lazy var viewStore = ViewStore(store)
  private var subscriptions = [AnyCancellable]()

  func newWorkspace() {
    viewStore.send(.openWorkspace(nil, isPersistent: true, workspaceID: nil))
  }

  func showOpenDialog() {
    let keyWindow = NSApplication.shared.keyWindow as? ColliderWindow
    viewStore.send(.showOpenDialog(workspaceID: keyWindow?.workspaceID))
  }

  func showWorkspaceWindow(_ workspaceID: WorkspaceState.ID) {
    let workspaceStore = store.workspace(workspaceID)
    workspaceStore.ifLet { [weak self] in
      guard let self = self else { return }

      if let window = self.windows[workspaceID] {
        window.close()
      }
      let window = ColliderWindow(
        self.viewStore,
        workspaceID,
        view: WorkspaceView($0),
        delegate: self
      )
      self.windows[workspaceID] = window
      self.ids[window] = workspaceID
    }.store(in: &subscriptions)
  }

  func launch() {
    viewStore.send(.launch(UserDefaults.standard.workspacePaths))
  }

  func windowShouldClose(_ sender: NSWindow) -> Bool {
    guard
      let window = sender as? ColliderWindow,
      let id = ids[window]
    else { return true }

    viewStore.send(.removeWorkspace(id))

    return true
  }
}
