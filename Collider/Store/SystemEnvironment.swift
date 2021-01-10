/*
 MIT License

 Copyright (c) 2020 Point-Free, Inc.

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import ComposableArchitecture
import Foundation

@dynamicMemberLookup
struct SystemEnvironment<Environment> {
  var date: () -> Date
  var environment: Environment
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var uuid: () -> UUID

  subscript<Dependency>(
    dynamicMember keyPath: WritableKeyPath<Environment, Dependency>
  ) -> Dependency {
    get { environment[keyPath: keyPath] }
    set { environment[keyPath: keyPath] = newValue }
  }

  /// Creates a live system environment with the wrapped environment provided.
  ///
  /// - Parameter environment: An environment to be wrapped in the system environment.
  /// - Returns: A new system environment.
  static func live(_ environment: Environment) -> Self {
    Self(
      date: Date.init,
      environment: environment,
      mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
      uuid: UUID.init
    )
  }

  /// Transforms the underlying wrapped environment.
  func map<NewEnvironment>(
    _ transform: @escaping (Environment) -> NewEnvironment
  ) -> SystemEnvironment<NewEnvironment> {
    .init(
      date: date,
      environment: transform(environment),
      mainQueue: mainQueue,
      uuid: uuid
    )
  }
}
