//
//  AppDelegate.swift
//  Collider
//
//  Created by Max Desiatov on 31/12/2020.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  private let windowManager = WindowManager()

  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let paths = UserDefaults.standard.workspacePaths

    guard !paths.isEmpty else {
      return windowManager.showWelcomeWindow()
    }

    windowManager.showWorkspaceWindows(paths)
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }
}
