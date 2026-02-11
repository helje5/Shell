//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018-2026 ZeeZide GmbH. All rights reserved.

#if canImport(Darwin)
  import Darwin
#elseif canImport(Glibc)
  import Glibc
#elseif canImport(Musl)
  import Musl
#endif

extension TaskPriority {

  /// The `TaskPriority` matching the current thread's QoS class.
  static var currentQoS : TaskPriority {
    switch qos_class_self() {
      case QOS_CLASS_USER_INTERACTIVE : .high
      case QOS_CLASS_USER_INITIATED   : .high
      case QOS_CLASS_UTILITY          : .low
      case QOS_CLASS_BACKGROUND       : .background
      default                         : .medium
    }
  }
}
