//
//  Created by Max Desiatov on 31/12/2020.
//

struct WorkspaceEnvironment {
  let navigationTab: NavigationTabEnvironment

  static let live = Self(navigationTab: .init(files: .init()))
}
