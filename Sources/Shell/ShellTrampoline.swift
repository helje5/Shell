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

@dynamicMemberLookup
public struct ShellTrampoline: Sendable {

  public let root : ShellPathTrampoline
  public var path : FilePath { root.path }

  public init(path: FilePath = "/") {
    self.root = ShellPathTrampoline(path: path)
  }

  public let env = EnvironmentTrampoline()

  public subscript(dynamicMember key: String) -> ShellPathTrampoline {
    let trampoline = root[dynamicMember: key]
    if trampoline.doesExist { return trampoline }
    return lookupInPATH(key) ?? trampoline
  }

  func lookupInPATH(_ k: String) -> ShellPathTrampoline? {
    let searchPath = env.PATH ?? "/usr/bin"

    for dir in searchPath.split(separator: ":") {
      let candidate = FilePath(String(dir)).appending(k)
      
      var sb = stat()
      guard stat(candidate.string, &sb) == 0,
            (sb.st_mode & S_IFMT) != S_IFDIR,
            access(candidate.string, X_OK) == 0 else {
        continue
      }
      
      return ShellPathTrampoline(path: candidate)
    }
    return nil
  }
}
