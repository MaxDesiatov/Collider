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

  var workspacePaths: [FilePath] {
    get {
      array(forKey: Keys.workspacePaths.description)?
        .compactMap { $0 as? String }
        .map(FilePath.init(stringLiteral:))
        ?? []
    }

    set {
      setValue(newValue.map(\.description), forKey: Keys.workspacePaths.description)
    }
  }
}
