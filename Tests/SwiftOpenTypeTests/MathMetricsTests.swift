import XCTest
import SwiftOpenType

final class MathMetricsTests: XCTestCase {
    func testTrivial() {
        XCTAssertTrue(true)
    }

    func testHasMathTable() {
        let helv = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
        XCTAssertFalse(helv.hasMathTable())

        let lmm = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)
        XCTAssertTrue(lmm.hasMathTable())
    }

    func testMathConstant() {
        XCTAssertEqual(MathConstants.scriptRatioScaleDown, 0)
        XCTAssertEqual(MathConstants.scriptScriptRatioScaleDown, 1)
    }

    static var allTests = [
        ("testTrivial", testTrivial),
        ("testHasMathTable", testHasMathTable),
    ]
}