import XCTest
@testable import Shell

final class ShellTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Shell().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
