import XCTest

import TcpConnectionTests

var tests = [XCTestCaseEntry]()
tests += TcpConnectionTests.allTests()
XCTMain(tests)