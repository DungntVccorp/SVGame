import XCTest

import GameServerTests

var tests = [XCTestCaseEntry]()
tests += GameServerTests.allTests()
XCTMain(tests)