//
//  EditorView.swift
//  Collider
//
//  Created by Max Desiatov on 10/01/2021.
//

import SwiftUI

struct EditorView: NSViewRepresentable {
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  func makeNSView(context: Context) -> MacEditor {
    MacEditor()
  }

  func updateNSView(_ nsView: NSViewType, context: Context) {
  }
}

extension EditorView {
  public class Coordinator {
  }
}
