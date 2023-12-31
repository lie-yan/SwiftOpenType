import XCTest
import SwiftOpenType

final class MathMetricsTests: XCTestCase {
    func testTrivial() {
        XCTAssertTrue(true)
    }

    func testHasMathTable() {
        let helv = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
        XCTAssertFalse(helv.mathTable != nil)

        let lmm = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)
        XCTAssertTrue(lmm.mathTable != nil)

        let mathTable = lmm.mathTable!
        XCTAssertEqual(mathTable.majorVersion, 1)
        XCTAssertEqual(mathTable.minorVersion, 0)
    }

    func testMathConstant() {
        XCTAssertEqual(MathConstants.scriptRatioScaleDown, 0)
        XCTAssertEqual(MathConstants.scriptScriptRatioScaleDown, 1)
    }

    static var allTests = [
        ("testTrivial", testTrivial),
        ("testHasMathTable", testHasMathTable),
        ("testMathConstant", testMathConstant),
    ]
}