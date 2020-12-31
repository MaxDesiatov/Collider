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

  var workspacePaths: [FilePath?] {
    get {
      array(forKey: Keys.workspacePaths.description)?
        .compactMap { $0 as? String }
        .map { $0.isEmpty ? nil : FilePath(stringLiteral: $0) }
        ?? []
    }

    set {
      setValue(
        newValue.map { (path: FilePath?) -> String in
          if let path = path {
            return path.description
          } else {
            return ""
          }
        },
        forKey: Keys.workspacePaths.description
      )
    }
  }
}
