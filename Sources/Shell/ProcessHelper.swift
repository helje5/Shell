//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018-2026 ZeeZide GmbH. All rights reserved.

import Subprocess

private let shellChars = Set(" \t\n\"'\\$`!#&|;(){}[]<>?*~")

private func shellQuote(_ argument: String) -> String {
  guard argument.contains(where: { shellChars.contains($0) }) else {
    return argument
  }
  var escaped = ""; escaped.reserveCapacity(argument.count + 4)
  for c in argument {
    if c == "'" { escaped += "'\\''"}
    else        { escaped.append(c) }
  }
  return "'\(escaped)'"
}

private let defaultLimit = 10 * 1024 * 1024 // 10MB

func launchSubprocess(at        path : String,
                      with arguments : [ String ],
                      using    shell : String? = "/bin/bash",
                      outputLimit    : Int = defaultLimit,
                      errorLimit     : Int = defaultLimit)
     async throws -> FancyResult
{
  let executable : Executable
  let args       : Arguments
  
  if let shell {
    let quoted = arguments.map(shellQuote)
    let fullCommand = shellQuote(path) + " " + quoted.joined(separator: " ")
    executable = .name(shell)
    args       = Arguments([ "-c", fullCommand ])
  }
  else {
    executable = .name(path)
    args       = Arguments(arguments)
  }

  let result = try await run(executable, arguments: args,
                             output : .bytes(limit: outputLimit),
                             error  : .bytes(limit: errorLimit))

  let exitCode = switch result.terminationStatus {
    case .exited            (let code)   : Int(code)
    case .unhandledException(let signal) : Int(signal)
  }

  return FancyResult(status     : exitCode,
                     outputData : result.standardOutput,
                     errorData  : result.standardError)
}
