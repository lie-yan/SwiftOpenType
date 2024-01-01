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

        let ruleThickness: CGFloat = 0.48
        let commonGap: CGFloat = 1.44
        let eps: CGFloat = 1e-15

        XCTAssertEqual(mathTable.scriptPercentScaleDown, 70)
        XCTAssertEqual(mathTable.scriptScriptPercentScaleDown, 50)

        XCTAssertEqual(mathTable.delimitedSubFormulaMinHeight, 15.6)
        XCTAssertEqual(mathTable.displayOperatorMinHeight, 15.6)

        XCTAssertEqual(mathTable.mathLeading, 1.848)
        XCTAssertEqual(mathTable.axisHeight, 3.0)
        XCTAssertEqual(mathTable.accentBaseHeight, 5.4)
        XCTAssertEqual(mathTable.flattenedAccentBaseHeight, 7.968)

        XCTAssertEqual(mathTable.subscriptShiftDown, 2.964)
        XCTAssertEqual(mathTable.subscriptTopMax, 4.128)
        XCTAssertEqual(mathTable.subscriptBaselineDropMin, 2.4)
        XCTAssertEqual(mathTable.superscriptShiftUp, 4.356)
        XCTAssertEqual(mathTable.superscriptShiftUpCramped, 3.468)
        XCTAssertEqual(mathTable.superscriptBottomMin, 1.296)
        XCTAssertEqual(mathTable.superscriptBaselineDropMax, 3.0)
        XCTAssertEqual(mathTable.subSuperscriptGapMin, 1.92)
        XCTAssertEqual(mathTable.superscriptBottomMaxWithSubscript, 4.128)
        XCTAssertEqual(mathTable.spaceAfterScript, 0.672)

        XCTAssertEqual(mathTable.upperLimitGapMin, 2.4)
        XCTAssertEqual(mathTable.upperLimitBaselineRiseMin, 1.332)
        XCTAssertEqual(mathTable.lowerLimitGapMin, 2.004)
        XCTAssertEqual(mathTable.lowerLimitBaselineDropMin, 7.2)

        XCTAssertEqual(mathTable.stackTopShiftUp, 5.328)
        XCTAssertEqual(mathTable.stackTopDisplayStyleShiftUp, 8.124)
        XCTAssertEqual(mathTable.stackBottomShiftDown, 4.14)
        XCTAssertEqual(mathTable.stackBottomDisplayStyleShiftDown, 8.232)
        XCTAssertEqual(mathTable.stackGapMin, 1.44)
        XCTAssertEqual(mathTable.stackDisplayStyleGapMin, 3.36)

        XCTAssertEqual(mathTable.stretchStackTopShiftUp, 1.332)
        XCTAssertEqual(mathTable.stretchStackBottomShiftDown, 7.2)
        XCTAssertEqual(mathTable.stretchStackGapAboveMin, 2.4)
        XCTAssertEqual(mathTable.stretchStackGapBelowMin, 2.004)

        XCTAssertEqual(mathTable.fractionNumeratorShiftUp, 4.728)
        XCTAssertEqual(mathTable.fractionNumeratorDisplayStyleShiftUp, 8.124)
        XCTAssertEqual(mathTable.fractionDenominatorShiftDown, 4.14)
        XCTAssertEqual(mathTable.fractionDenominatorDisplayStyleShiftDown, 8.232)
        XCTAssertEqual(mathTable.fractionNumeratorGapMin, ruleThickness)
        XCTAssertEqual(mathTable.fractionNumDisplayStyleGapMin, commonGap)
        XCTAssertEqual(mathTable.fractionRuleThickness, ruleThickness)
        XCTAssertEqual(mathTable.fractionDenominatorGapMin, ruleThickness)
        XCTAssertEqual(mathTable.fractionDenomDisplayStyleGapMin, commonGap)

        XCTAssertEqual(mathTable.skewedFractionHorizontalGap, 4.2)
        XCTAssertEqual(mathTable.skewedFractionVerticalGap, 1.152, accuracy: eps)

        XCTAssertEqual(mathTable.overbarVerticalGap, commonGap)
        XCTAssertEqual(mathTable.overbarRuleThickness, ruleThickness)
        XCTAssertEqual(mathTable.overbarExtraAscender, ruleThickness)

        XCTAssertEqual(mathTable.underbarVerticalGap, commonGap)
        XCTAssertEqual(mathTable.underbarRuleThickness, ruleThickness)
        XCTAssertEqual(mathTable.underbarExtraDescender, ruleThickness)

        XCTAssertEqual(mathTable.radicalVerticalGap, 0.6)
        XCTAssertEqual(mathTable.radicalDisplayStyleVerticalGap, 1.776)
        XCTAssertEqual(mathTable.radicalRuleThickness, ruleThickness)
        XCTAssertEqual(mathTable.radicalExtraAscender, ruleThickness)
        XCTAssertEqual(mathTable.radicalKernBeforeDegree, 3.336)
        XCTAssertEqual(mathTable.radicalKernAfterDegree, -6.672)

        XCTAssertEqual(mathTable.radicalDegreeBottomRaisePercent, 60)
    }

    static var allTests = [
        ("testMathTableHeader", testMathTableHeader),
        ("testMathConstants", testMathConstants)
    ]
}