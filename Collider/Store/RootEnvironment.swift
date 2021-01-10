//
//  Created by Max Desiatov on 30/12/2020.
//

import AppKit
import ComposableArchitecture
import System

private extension URL {
  var isDirectory: Bool {
     return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
  }
}

private extension FilePath {
  func retrieveChildren() throws -> [FileItem] {
    let url = URL(fileURLWithPath: description)

    return try FileManager.default.contentsOfDirectory(atPath: description)
      .filter { !($0.first == ".") }
      .compactMap { (name: String) -> FileItem? in
        let itemURL = url.appendingPathComponent(name)
        return try FileItem(
          name: name,
          path: .init(itemURL.path),
          children: itemURL.isDirectory ? FilePath(itemURL.path).retrieveChildren() : nil
        )
      }
  }
}

struct RootEnvironment {
  var showOpenDialog: () -> Effect<URL?, Never>
  var traverse: (FilePath) -> Effect<FileItem, Error>
  var openWorkspace: (FilePath?, _ isPersistent: Bool, WorkspaceState.ID) -> ()
  var removeWorkspace: (WorkspaceState.ID) -> ()
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
      traverse: { path in
        let url = URL(fileURLWithPath: path.description)
        return .catching {
          try FileItem(
            name: url.lastPathComponent,
            path: .init(url.path),
            children: path.retrieveChildren()
          )
        }
      },
      openWorkspace: { [weak windowManager] filePath, isPersistent, workspaceID in
        if isPersistent {
          UserDefaults.standard.workspacePaths[workspaceID] = filePath?.description ?? ""
        }

        if filePath != nil {
          windowManager?.showWorkspaceWindow(workspaceID)
        } else {
          windowManager?.showWelcomeWindow(workspaceID)
        }
      },
      removeWorkspace: { UserDefaults.standard.workspacePaths[$0] = nil },
      showAlert: {
        let alert = NSAlert()
        alert.messageText = $0.localizedDescription
        alert.runModal()
      },
      workspace: .live
    ))
  }
}
