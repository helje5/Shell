import XCTest
@testable import Shell

final class ShellAsyncTests: XCTestCase {

  func testSwiftVersionCall() async throws {
    let result = await shell.swift("--version")
    print("R:", result)
    XCTAssertTrue(result.stdout.hasPrefix("Apple Swift"))
    XCTAssertEqual(result.status, 0)
  }

  func testLSCall() async throws {
    let result = await shell.bin.ls("/Users/")
    print("R:", result)
    XCTAssertEqual(result.status, 0, "unexpected result: \(result)")
    XCTAssertFalse(result.stdout.isEmpty, "unexpected result: \(result)")
    let files = await shell.ls("/Users/")
    for file in files.split(separator: "\n") {
      print("dir:", file)
    }
  }

  func testHostCall() async throws {
    let result = await shell.host("zeezide.de")
    print("R:", result)
    XCTAssertEqual(result.status, 0, "unexpected result: \(result)")
    XCTAssertFalse(result.stdout.isEmpty, "unexpected result: \(result)")
    XCTAssertTrue(result.stdout.contains("zeezide.de"))
    print(result.stdout)
  }

  // MARK: - Validation Errors

  func testNotFound() async throws {
    let result = await shell.usr.bin.doesnotexist_xyzzy("--help")
    XCTAssertEqual(result.status, 1)
    XCTAssertFalse(result.isSuccess)
    XCTAssertTrue(
      result.stderr.contains("No such file or directory"))
  }

  func testIsDirectory() async throws {
    let trampoline = ShellPathTrampoline(path: "/usr")
    let result = await trampoline()
    XCTAssertEqual(result.status, 2)
    XCTAssertFalse(result.isSuccess)
    XCTAssertTrue(result.stderr.contains("is a directory"))
  }

  func testNotExecutable() async throws {
    let trampoline =
      ShellPathTrampoline(path: "/etc/hosts")
    let result = await trampoline()
    XCTAssertEqual(result.status, 99)
    XCTAssertFalse(result.isSuccess)
    XCTAssertTrue(result.stderr.contains("Permission denied"))
  }

  // MARK: - Nonzero Exit

  func testNonzeroExit() async throws {
    let result = await shell.ls("/nonexistent_path_xyzzy")
    XCTAssertNotEqual(result.status, 0)
    XCTAssertFalse(result.isSuccess)
    XCTAssertFalse(result.stderr.isEmpty)
  }

  // MARK: - Throwing run()

  func testRunMethod() async throws {
    let result = try await shell.swift.run("--version")
    XCTAssertEqual(result.status, 0)
    XCTAssertTrue(result.stdout.hasPrefix("Apple Swift"))
  }

  func testRunMethodValidationError() async throws {
    let trampoline = ShellPathTrampoline(path: "/usr")
    let result = try await trampoline.run()
    XCTAssertEqual(result.status, 2)
    XCTAssertTrue(result.stderr.contains("is a directory"))
  }
}
