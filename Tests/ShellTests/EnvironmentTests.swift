import XCTest
@testable import Shell

final class EnvironmentTests: XCTestCase {

  func testEnvironmentVariable() {
    let home = shell.env.HOME
    XCTAssertNotNil(home)
    XCTAssertFalse(home?.isEmpty ?? true)
  }

  func testEnvironmentVariableMissing() {
    let value = shell.env.XYZZY_NONEXISTENT_VAR_12345
    XCTAssertNil(value)
  }
}
