//
//  AppDelegate.swift
//  Collider
//
//  Created by Max Desiatov on 31/12/2020.
//

import ComposableArchitecture
import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  private let store = Store(
    initialState: RootState(),
    reducer: rootReducer,
    environment: RootEnvironment.live
  )

  var windows = [NSWindow]()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let paths = UserDefaults.standard.workspacePaths

    guard !paths.isEmpty else {
      return windows.append(.init(view: WelcomeView(), autosave: "WelcomeView"))
    }

    for (index, path) in paths.enumerated() {
      windows.append(.init(view: WorkspaceView(store.workspace(index)), autosave: path.description))
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
