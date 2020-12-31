//
//  Created by Max Desiatov on 31/12/2020.
//

import SwiftUI

private final class Lifecycle: ObservableObject {
  init(onLoad: () -> (), onUnload: @escaping () -> ()) {
    onLoad()
    self.onUnload = onUnload
  }

  let onUnload: () -> ()

  deinit {
    onUnload()
  }
}

struct LifecycleView<Content: View>: View {
  @StateObject private var lifecycle: Lifecycle
  let content: Content

  init(
    onLoad: @escaping () -> (),
    onUnload: @escaping () -> () = {},
    @ViewBuilder content: () -> Content
  ) {
    _lifecycle = StateObject(wrappedValue: Lifecycle(onLoad: onLoad, onUnload: onUnload))
    self.content = content()
  }

  var body: some View {
    content
  }
}
