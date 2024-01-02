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
        let mathConstants = lmmath.mathTable!.mathConstantsTable

        let ruleThickness: CGFloat = 0.48
        let commonGap: CGFloat = 1.44
        let eps: CGFloat = 1e-15

        XCTAssertEqual(mathConstants.scriptPercentScaleDown, 0.7)
        XCTAssertEqual(mathConstants.scriptScriptPercentScaleDown, 0.5)

        XCTAssertEqual(mathConstants.delimitedSubFormulaMinHeight, 15.6)
        XCTAssertEqual(mathConstants.displayOperatorMinHeight, 15.6)

        XCTAssertEqual(mathConstants.mathLeading, 1.848)
        XCTAssertEqual(mathConstants.axisHeight, 3.0)
        XCTAssertEqual(mathConstants.accentBaseHeight, 5.4)
        XCTAssertEqual(mathConstants.flattenedAccentBaseHeight, 7.968)

        XCTAssertEqual(mathConstants.subscriptShiftDown, 2.964)
        XCTAssertEqual(mathConstants.subscriptTopMax, 4.128)
        XCTAssertEqual(mathConstants.subscriptBaselineDropMin, 2.4)
        XCTAssertEqual(mathConstants.superscriptShiftUp, 4.356)
        XCTAssertEqual(mathConstants.superscriptShiftUpCramped, 3.468)
        XCTAssertEqual(mathConstants.superscriptBottomMin, 1.296)
        XCTAssertEqual(mathConstants.superscriptBaselineDropMax, 3.0)
        XCTAssertEqual(mathConstants.subSuperscriptGapMin, 1.92)
        XCTAssertEqual(mathConstants.superscriptBottomMaxWithSubscript, 4.128)
        XCTAssertEqual(mathConstants.spaceAfterScript, 0.672)

        XCTAssertEqual(mathConstants.upperLimitGapMin, 2.4)
        XCTAssertEqual(mathConstants.upperLimitBaselineRiseMin, 1.332)
        XCTAssertEqual(mathConstants.lowerLimitGapMin, 2.004)
        XCTAssertEqual(mathConstants.lowerLimitBaselineDropMin, 7.2)

        XCTAssertEqual(mathConstants.stackTopShiftUp, 5.328)
        XCTAssertEqual(mathConstants.stackTopDisplayStyleShiftUp, 8.124)
        XCTAssertEqual(mathConstants.stackBottomShiftDown, 4.14)
        XCTAssertEqual(mathConstants.stackBottomDisplayStyleShiftDown, 8.232)
        XCTAssertEqual(mathConstants.stackGapMin, 1.44)
        XCTAssertEqual(mathConstants.stackDisplayStyleGapMin, 3.36)

        XCTAssertEqual(mathConstants.stretchStackTopShiftUp, 1.332)
        XCTAssertEqual(mathConstants.stretchStackBottomShiftDown, 7.2)
        XCTAssertEqual(mathConstants.stretchStackGapAboveMin, 2.4)
        XCTAssertEqual(mathConstants.stretchStackGapBelowMin, 2.004)

        XCTAssertEqual(mathConstants.fractionNumeratorShiftUp, 4.728)
        XCTAssertEqual(mathConstants.fractionNumeratorDisplayStyleShiftUp, 8.124)
        XCTAssertEqual(mathConstants.fractionDenominatorShiftDown, 4.14)
        XCTAssertEqual(mathConstants.fractionDenominatorDisplayStyleShiftDown, 8.232)
        XCTAssertEqual(mathConstants.fractionNumeratorGapMin, ruleThickness)
        XCTAssertEqual(mathConstants.fractionNumDisplayStyleGapMin, commonGap)
        XCTAssertEqual(mathConstants.fractionRuleThickness, ruleThickness)
        XCTAssertEqual(mathConstants.fractionDenominatorGapMin, ruleThickness)
        XCTAssertEqual(mathConstants.fractionDenomDisplayStyleGapMin, commonGap)

        XCTAssertEqual(mathConstants.skewedFractionHorizontalGap, 4.2)
        XCTAssertEqual(mathConstants.skewedFractionVerticalGap, 1.152, accuracy: eps)

        XCTAssertEqual(mathConstants.overbarVerticalGap, commonGap)
        XCTAssertEqual(mathConstants.overbarRuleThickness, ruleThickness)
        XCTAssertEqual(mathConstants.overbarExtraAscender, ruleThickness)

        XCTAssertEqual(mathConstants.underbarVerticalGap, commonGap)
        XCTAssertEqual(mathConstants.underbarRuleThickness, ruleThickness)
        XCTAssertEqual(mathConstants.underbarExtraDescender, ruleThickness)

        XCTAssertEqual(mathConstants.radicalVerticalGap, 0.6)
        XCTAssertEqual(mathConstants.radicalDisplayStyleVerticalGap, 1.776)
        XCTAssertEqual(mathConstants.radicalRuleThickness, ruleThickness)
        XCTAssertEqual(mathConstants.radicalExtraAscender, ruleThickness)
        XCTAssertEqual(mathConstants.radicalKernBeforeDegree, 3.336)
        XCTAssertEqual(mathConstants.radicalKernAfterDegree, -6.672)

        XCTAssertEqual(mathConstants.radicalDegreeBottomRaisePercent, 0.6)
    }

    func testMathItalicsCorrectionInfo() {
        let coverageTable = lmmath.mathTable!.mathGlyphInfoTable.mathItalicsCorrectionInfoTable.coverageTable
        XCTAssert(coverageTable.coverageFormat() == 1)
        print("glyphCount: \(coverageTable.glyphCount())")
    }
}