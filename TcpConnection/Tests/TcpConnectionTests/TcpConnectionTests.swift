import XCTest
import Dispatch
@testable import TcpConnection

final class TcpConnectionTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let tcp =  TcpConnection(1234)
        XCTAssertNil(tcp)
        dispatchMain()
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
