import XCTest

import ShellTests

var tests = [XCTestCaseEntry]()
tests += ShellTests.allTests()
XCTMain(tests)
