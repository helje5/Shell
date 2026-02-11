//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018-2026 ZeeZide GmbH. All rights reserved.

public struct FancyResult: Sendable {

  public let status     : Int
  public let outputData : [ UInt8 ]
  public let errorData  : [ UInt8 ]

  public var isSuccess  : Bool { status == 0 }

  public var stdout : String {
    String(decoding: outputData, as: UTF8.self)
  }
  public var stderr : String {
    String(decoding: errorData, as: UTF8.self)
  }

  public func split(separator: Character) -> [ Substring ] {
    stdout.split(separator: separator)
  }
}

extension FancyResult: CustomStringConvertible {

  public var description : String {

    func string(for data: [ UInt8 ], maxWidth: Int = 72) -> String {
      guard data.count <= 2_000 else {
        return "\(data.count) bytes"
      }
      let s = String(decoding: data, as: UTF8.self)
      return s.count > maxWidth
        ? String(s[..<s.index(s.startIndex, offsetBy: maxWidth)]) + "…"
        : s
    }

    if isSuccess, errorData.isEmpty {
      return string(for: outputData)
    }

    var ms = "<ProcessResult:"
    if status != 0 { ms += " \(status)" }

    ms += " \"\(string(for: outputData))\""
    if !errorData.isEmpty {
      ms += " stderr=\"\(string(for: errorData))\""
    }

    ms += ">"
    return ms
  }
}
