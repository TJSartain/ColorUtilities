import XCTest
@testable import ColorUtilities

final class ColorUtilitiesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ColorUtilities().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
