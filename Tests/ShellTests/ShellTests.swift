import XCTest
@testable import Shell

final class ShellTests: XCTestCase {
  
    func testSwiftVersionCall() {
        let result = shell.swift("--version")
        XCTAssert(result.stdout.hasPrefix("Apple Swift"))
    }
  
    func testLSCall() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        for file in shell.ls("/Users/").split(separator: "\n") {
            print("dir:", file)
        }
    }

    static var allTests = [
        ("testSwiftVersionCall", testSwiftVersionCall),
        ("testLSCall",           testLSCall)
    ]
}
