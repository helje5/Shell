//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018-2026 ZeeZide GmbH. All rights reserved.

#if canImport(Darwin)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#elseif canImport(Musl)
  import Musl
#elseif canImport(ucrt)
  import ucrt
#endif

@dynamicMemberLookup
public struct EnvironmentTrampoline: Sendable {

  public subscript(dynamicMember k: String) -> String? {
    return getenv(k).flatMap { String(cString: $0) }
  }
}
