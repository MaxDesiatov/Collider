//
//  RootEnvironment.swift
//  Ned
//
//  Created by Max Desiatov on 30/12/2020.
//

import AppKit
import ComposableArchitecture

struct RootEnvironment {
  var open: () -> Effect<FileItem?, Never>
}

let rootEnvironment = RootEnvironment(
  open: {
    .future { promise in
      let openPanel = NSOpenPanel()
      openPanel.canChooseFiles = true
      openPanel.canChooseDirectories = true
      openPanel.begin { result in
        if result == .OK {
          if let url = openPanel.url {
            let children = try? FileManager.default.contentsOfDirectory(atPath:url.path)
              .compactMap { name -> FileItem? in
                guard let name = name as? String else { return nil }
                return FileItem(
                  name: name,
                  path: .init(url.appendingPathComponent(name).path),
                  children: []
                )
              }
            promise(
              .success(
                FileItem(name: url.lastPathComponent, path: .init(url.path), children: children)
              )
            )
          }
        } else if result == .cancel {
          promise(.success(nil))
        }
      }
    }
  }
)
