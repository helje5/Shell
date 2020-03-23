//  Created by Helge Hess on 21.12.18.
//  Copyright © 2018-2020 ZeeZide GmbH. All rights reserved.

import Foundation

extension Process {
  
    public struct FancyResult {
      // Not that fancy actually :-) Convenience before everything!!!
    
      public let status     : Int
      public let outputData : Data
      public let errorData  : Data
    
      public var isSuccess  : Bool { return status == 0 }
    
      public var stdout : String {
          return String(data: outputData, encoding: .utf8) ?? "<binary data>"
      }
      public var stderr : String {
          return String(data: errorData, encoding: .utf8) ?? "<binary data>"
      }
    
      public func split(separator: Character) -> [ Substring ] {
          return stdout.split(separator: separator)
      }

    }
  
    static func launch(at launchPath: String, with arguments: [ String ],
                       using shell: String? = "/bin/bash")
                -> FancyResult
    {
        let process = Process()
        process.launchPath = shell ?? launchPath
        process.arguments  = shell != nil
            ? [ "-c", launchPath + " " + arguments.joined(separator: " ") ]
            : arguments
    
        let stdout = Pipe()
        let stderr = Pipe()
        process.standardOutput = stdout
        process.standardError  = stderr
    
        var outputData = Data()
        var errorData  = Data()
    
        let Q = DispatchQueue(label: "shell")
    
        stdout.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            Q.async { outputData.append(data) }
        }
        stderr.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            Q.async { errorData.append(data) }
        }
    
        process.launch()
        process.waitUntilExit()
    
        stdout.fileHandleForReading.readabilityHandler = nil
        stderr.fileHandleForReading.readabilityHandler = nil
        Q.async {
            stdout.fileHandleForReading.closeFile()
            stderr.fileHandleForReading.closeFile()
        }
    
        return Q.sync {
            return FancyResult(status     : Int(process.terminationStatus),
                               outputData : outputData,
                               errorData  : errorData )
        }
    }
}

extension Process.FancyResult : CustomStringConvertible {
  
    public var description : String {
    
        func string(for data: Data) -> String {
            guard let s = String(data: data, encoding: .utf8) else {
                return data.description
            }
            if s.count > 72 {
                return String(s[..<s.index(s.startIndex, offsetBy: 72)]) + "..."
            }
            return s
        }
    
        if isSuccess, errorData.isEmpty { return string(for: outputData) }
    
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
