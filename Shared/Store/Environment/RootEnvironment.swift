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
              .filter { !($0.first == ".") }
              .compactMap { (name: String) -> FileItem? in
                FileItem(
                  name: name,
                  path: .init(url.appendingPathComponent(name).path),
                  children: nil
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
