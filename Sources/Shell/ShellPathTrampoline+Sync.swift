//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018-2026 ZeeZide GmbH. All rights reserved.

import Dispatch

/**
 * Synchronous wrapper around the async subprocess launch.
 *
 * Uses `Task.detached` + `DispatchSemaphore` to bridge async
 * into sync. **Deadlock warning:** if called on a thread from
 * the cooperative thread pool (e.g. inside a `Task {}` or an
 * actor), `sema.wait()` blocks a thread the executor needs to
 * make progress, which can deadlock. Only call this from a
 * plain (non-async) context such as `main()` or a Dispatch /
 * pthread thread.
 */
extension ShellPathTrampoline {

  @discardableResult
  public func dynamicallyCall(withArguments arguments: [ String ])
              -> FancyResult
  {
    if let error = validate() { return error }
    
    let p    = path.string
    let sema = DispatchSemaphore(value: 0)
    nonisolated(unsafe) var result =
      FancyResult(status: -1, outputData: [], errorData: [])

    Task.detached(priority: .currentQoS) { @Sendable in
      do {
        result = try await launchSubprocess(at: p, with: arguments)
      }
      catch {
        let msg = "\(p): \(error)"
        result = FancyResult(status: -1, outputData: [],
                             errorData: Array(msg.utf8))
      }
      sema.signal()
    }
    sema.wait()
    return result
  }
}
