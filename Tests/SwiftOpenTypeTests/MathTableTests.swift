import XCTest
import SwiftOpenType

final class MathTableTests: XCTestCase {

    let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
    let lmmath = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)

    func testMathTableHeader() {
        XCTAssertFalse(helvetica.mathTable != nil)

        XCTAssertTrue(lmmath.mathTable != nil)

        let mathTable = lmmath.mathTable!
        XCTAssertEqual(mathTable.majorVersion, 1)
        XCTAssertEqual(mathTable.minorVersion, 0)
    }

    func testMathConstants() {
        let mathTable = lmmath.mathTable!

        XCTAssertEqual(mathTable.scriptPercentScaleDown, 0.7)
        XCTAssertEqual(mathTable.scriptScriptPercentScaleDown, 0.5)

        XCTAssertEqual(mathTable.delimitedSubFormulaMinHeight, 15.6)

    }

    static var allTests = [
        ("testMathTableHeader", testMathTableHeader),
    ]
}