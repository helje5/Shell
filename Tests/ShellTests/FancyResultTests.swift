import XCTest
@testable import Shell

final class FancyResultTests: XCTestCase {

  func testDescriptionSuccess() {
    let result = FancyResult(
      status: 0,
      outputData: Array("hello\n".utf8),
      errorData: []
    )
    XCTAssertTrue(result.isSuccess)
    XCTAssertEqual(result.description, "hello\n")
  }

  func testDescriptionError() {
    let result = FancyResult(
      status: 1,
      outputData: [],
      errorData: Array("oops".utf8)
    )
    XCTAssertFalse(result.isSuccess)
    XCTAssertTrue(result.description.contains("ProcessResult"))
    XCTAssertTrue(result.description.contains("1"))
    XCTAssertTrue(result.description.contains("oops"))
  }

  func testDescriptionTruncation() {
    let long = String(repeating: "x", count: 100)
    let result = FancyResult(
      status: 0,
      outputData: Array(long.utf8),
      errorData: []
    )
    // Success with empty error uses string(for: outputData)
    // which truncates at 72 chars + "…"
    XCTAssertTrue(result.description.hasSuffix("…"))
    XCTAssertLessThanOrEqual(result.description.count, 73 + 1)
  }
}
