import XCTest
@testable import Shell

final class ShellSyncTests: XCTestCase {

  func testSyncCall() {
    let result = shell.bin.ls("/Users/")
    XCTAssertEqual(result.status, 0, "unexpected result: \(result)")
    XCTAssertFalse(result.stdout.isEmpty, "unexpected result: \(result)")
  }

  func testNotFound() {
    let result = shell.bin.dir()
    XCTAssertEqual(result.status, 1)
    XCTAssertFalse(result.isSuccess)
    XCTAssertTrue(result.stderr.contains("No such file or directory"))
  }
}
