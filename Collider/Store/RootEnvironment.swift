//
//  Created by Max Desiatov on 30/12/2020.
//

import AppKit
import ComposableArchitecture
import System

struct RootEnvironment {
  var showOpenDialog: () -> Effect<URL?, Never>
  var traverse: (URL) -> Effect<FileItem, Error>
  var openWorkspace: (FilePath?, _ isPersistent: Bool) -> ()
  var removeWorkspace: (Int) -> ()
  var showAlert: (Error) -> ()

  var workspace: WorkspaceEnvironment

  static func live(_ windowManager: WindowManager) -> SystemEnvironment<Self> {
    SystemEnvironment.live(RootEnvironment(
      showOpenDialog: {
        .future { promise in
          let openPanel = NSOpenPanel()
          openPanel.canChooseFiles = true
          openPanel.canChooseDirectories = true
          openPanel.begin { result in
            if result == .OK {
              if let url = openPanel.url {
                promise(.success(url))
              }
            } else if result == .cancel {
              promise(.success(nil))
            }
          }
        }
      },
      traverse: { url in
        .catching {
          let children = try FileManager.default.contentsOfDirectory(atPath: url.path)
            .filter { !($0.first == ".") }
            .compactMap { (name: String) -> FileItem? in
              FileItem(
                name: name,
                path: .init(url.appendingPathComponent(name).path),
                children: nil
              )
            }

          return FileItem(name: url.lastPathComponent, path: .init(url.path), children: children)
        }
      },
      openWorkspace: { [weak windowManager] filePath, isPersistent in
        if isPersistent {
          UserDefaults.standard.workspacePaths.append(filePath)
        }

        if let filePath = filePath {
        } else {
            windowManager?.showWelcomeWindow()
        }
      },
      removeWorkspace: { UserDefaults.standard.workspacePaths.remove(at: $0) },
      showAlert: {
        let alert = NSAlert()
        alert.messageText = $0.localizedDescription
        alert.runModal()
      },
      workspace: .live
    ))
  }
}
