//
//  Created by Max Desiatov on 31/12/2020.
//

import Foundation
import System

extension UserDefaults {
  private enum Keys: String, CustomStringConvertible {
    case workspacePaths

    var description: String {
      "com.dsignal.Collider.\(rawValue)"
    }
  }

  /// Empty path string denotes an empty workspace
  var workspacePaths: [WorkspaceState.ID: String] {
    get {
      .init(
        dictionary(forKey: Keys.workspacePaths.description)?
          .compactMap({ (id, path) -> (WorkspaceState.ID, String)? in
            guard
              let path = path as? String,
              let id = WorkspaceState.ID(uuidString: id)
            else { return nil }

            return (id, path)
          }) ?? [],
        uniquingKeysWith: { $1 }
      )
    }

    set {
      setValue(
        [String: String](newValue.map { ($0.description, $1) }, uniquingKeysWith: { $1 }),
        forKey: Keys.workspacePaths.description
      )
    }
  }
}
