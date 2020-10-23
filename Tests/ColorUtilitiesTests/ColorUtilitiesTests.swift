import XCTest
@testable import ColorUtilities

final class ColorUtilitiesTests: XCTestCase
{
    func testHexColor()
    {
        let testColor = UIColor(red: 17.0/255, green: 34.0/255, blue: 51.0/255, alpha: 1)
        XCTAssertEqual(from(hex: "123"), testColor, "hexColor didn't work for '123'")
    }

    func testFromCSV()
    {
        let testColor = UIColor(red: 17.0/255, green: 34.0/255, blue: 51.0/255, alpha: 1)
        print(testColor.description)
        print(testColor)
        XCTAssertEqual(from(csv: "(17, 34, 51)"), testColor, "fromCSV didn't work for (17, 34, 51)")
    }

    static var allTests = [
        ("testHexColor", testHexColor),
        ("testHexColor", testFromCSV),
    ]
}
