//
//  Created by Max Desiatov on 30/12/2020.
//

import AppKit
import ComposableArchitecture
import System

struct RootEnvironment {
  var open: () -> Effect<URL?, Never>
  var traverse: (URL) -> Effect<FileItem, Error>
  var addWorkspace: (FilePath?) -> ()
  var removeWorkspace: (Int) -> ()
  var showAlert: (Error) -> ()

  var workspace: WorkspaceEnvironment

  static let live = SystemEnvironment.live(RootEnvironment(
    open: {
      .future { promise in
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = true
        openPanel.begin { result in
          if result == .OK {
            if let url = openPanel.url {
              promise( .success(url ) )
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
    addWorkspace: { UserDefaults.standard.workspacePaths.append($0) },
    removeWorkspace: { UserDefaults.standard.workspacePaths.remove(at: $0) },
    showAlert: {
      let alert = NSAlert()
      alert.messageText = $0.localizedDescription
      alert.runModal()
    },
    workspace: .live
  ))
}
