import XCTest
@testable import Shell

final class ShellTests: XCTestCase {
  
    func testSwiftVersionCall() {
        let result = shell.swift("--version")
        XCTAssert(result.stdout.hasPrefix("Apple Swift"))
        XCTAssert(result.status == 0)
    }
  
    func testLSCall() {
        // swift runs stuff with PATH having just /usr/bin
        let result = shell.bin.ls("/Users/")
        XCTAssert(result.status == 0, "unexpected result: \(result)")
        XCTAssert(!result.stdout.isEmpty, "unexpected result: \(result)")
        for file in shell.ls("/Users/").split(separator: "\n") {
            print("dir:", file)
        }
    }
    
    func testHostCall() {
        let result = shell.host("zeezide.de")
        XCTAssert(result.status == 0, "unexpected result: \(result)")
        XCTAssert(!result.stdout.isEmpty, "unexpected result: \(result)")
        XCTAssert(result.stdout.contains("zeezide.de"))
        print(result.stdout)
    }

    static var allTests = [
        ("testSwiftVersionCall", testSwiftVersionCall),
        ("testLSCall",           testLSCall),
        ("testHostCall",         testHostCall)
    ]
}
