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

    static var allTests = [
        ("testTrivial", testTrivial),
    ]
}