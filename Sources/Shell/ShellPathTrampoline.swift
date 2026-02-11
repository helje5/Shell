//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018-2026 ZeeZide GmbH. All rights reserved.

#if canImport(Darwin)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#elseif canImport(Musl)
  import Musl
#endif
import SystemPackage

@dynamicCallable
@dynamicMemberLookup
public struct ShellPathTrampoline: Sendable {

  public let path : FilePath

  public init(path: FilePath) {
    self.path = path
  }

  public subscript(dynamicMember key: String) -> ShellPathTrampoline {
    ShellPathTrampoline(path: path.appending(key))
  }

  var doesExist : Bool {
    access(path.string, F_OK) == 0
  }

  var isDirectory : Bool {
    var sb = stat()
    guard stat(path.string, &sb) == 0 else { return false }
    return (sb.st_mode & S_IFMT) == S_IFDIR
  }

  // MARK: - Validation

  func makeError(code: Int, info: String) -> FancyResult {
    let error = Array("\(path.string): \(info)".utf8)
    return FancyResult(status: code, outputData: [], errorData: error)
  }

  func validate() -> FancyResult? {
    guard doesExist else {
      return makeError(code: 1, info: "No such file or directory")
    }
    guard !isDirectory else {
      return makeError(code: 2, info: "Is a directory")
    }
    guard access(path.string, X_OK) == 0 else {
      return makeError(code: 99, info: "Permission denied, not executable.")
    }
    return nil
  }

  // MARK: - Async Call

  @discardableResult
  public func dynamicallyCall(withArguments arguments: [ String ]) async
              -> FancyResult
  {
    if let error = validate() { return error }
    do {
      return try await launchSubprocess(at: path.string, with: arguments)
    }
    catch {
      let msg = "\(path.string): \(error)"
      return FancyResult(status: -1, outputData: [], errorData: Array(msg.utf8))
    }
  }

  // MARK: - Throwing Async

  /**
   * Runs the command, throwing on subprocess launch errors.
   * Validation errors are returned in `FancyResult`.
   */
  public func run(_ arguments: String...) async throws -> FancyResult {
    if let error = validate() { return error }
    return try await launchSubprocess(at: path.string, with: arguments)
  }
}
