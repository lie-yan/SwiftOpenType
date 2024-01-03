import XCTest
@testable import SwiftOpenType

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

        let toRatio = {(p: Int32) -> CGFloat in CGFloat(p) / 100}
        let toPoints = {(du: Int32) -> CGFloat in CGFloat(du) * self.lmmath.sizePerUnit()}

        XCTAssertEqual(toRatio(mathConstants.scriptPercentScaleDown), 0.7)
        XCTAssertEqual(toRatio(mathConstants.scriptScriptPercentScaleDown), 0.5)

        XCTAssertEqual(toPoints(mathConstants.delimitedSubFormulaMinHeight), 15.6)
        XCTAssertEqual(toPoints(mathConstants.displayOperatorMinHeight), 15.6)

        XCTAssertEqual(toPoints(mathConstants.mathLeading), 1.848)
        XCTAssertEqual(toPoints(mathConstants.axisHeight), 3.0)
        XCTAssertEqual(toPoints(mathConstants.accentBaseHeight), 5.4)
        XCTAssertEqual(toPoints(mathConstants.flattenedAccentBaseHeight), 7.968)

        XCTAssertEqual(toPoints(mathConstants.subscriptShiftDown), 2.964)
        XCTAssertEqual(toPoints(mathConstants.subscriptTopMax), 4.128)
        XCTAssertEqual(toPoints(mathConstants.subscriptBaselineDropMin), 2.4)
        XCTAssertEqual(toPoints(mathConstants.superscriptShiftUp), 4.356)
        XCTAssertEqual(toPoints(mathConstants.superscriptShiftUpCramped), 3.468)
        XCTAssertEqual(toPoints(mathConstants.superscriptBottomMin), 1.296)
        XCTAssertEqual(toPoints(mathConstants.superscriptBaselineDropMax), 3.0)
        XCTAssertEqual(toPoints(mathConstants.subSuperscriptGapMin), 1.92)
        XCTAssertEqual(toPoints(mathConstants.superscriptBottomMaxWithSubscript), 4.128)
        XCTAssertEqual(toPoints(mathConstants.spaceAfterScript), 0.672)

        XCTAssertEqual(toPoints(mathConstants.upperLimitGapMin), 2.4)
        XCTAssertEqual(toPoints(mathConstants.upperLimitBaselineRiseMin), 1.332)
        XCTAssertEqual(toPoints(mathConstants.lowerLimitGapMin), 2.004)
        XCTAssertEqual(toPoints(mathConstants.lowerLimitBaselineDropMin), 7.2)

        XCTAssertEqual(toPoints(mathConstants.stackTopShiftUp), 5.328)
        XCTAssertEqual(toPoints(mathConstants.stackTopDisplayStyleShiftUp), 8.124)
        XCTAssertEqual(toPoints(mathConstants.stackBottomShiftDown), 4.14)
        XCTAssertEqual(toPoints(mathConstants.stackBottomDisplayStyleShiftDown), 8.232)
        XCTAssertEqual(toPoints(mathConstants.stackGapMin), 1.44)
        XCTAssertEqual(toPoints(mathConstants.stackDisplayStyleGapMin), 3.36)

        XCTAssertEqual(toPoints(mathConstants.stretchStackTopShiftUp), 1.332)
        XCTAssertEqual(toPoints(mathConstants.stretchStackBottomShiftDown), 7.2)
        XCTAssertEqual(toPoints(mathConstants.stretchStackGapAboveMin), 2.4)
        XCTAssertEqual(toPoints(mathConstants.stretchStackGapBelowMin), 2.004)

        XCTAssertEqual(toPoints(mathConstants.fractionNumeratorShiftUp), 4.728)
        XCTAssertEqual(toPoints(mathConstants.fractionNumeratorDisplayStyleShiftUp), 8.124)
        XCTAssertEqual(toPoints(mathConstants.fractionDenominatorShiftDown), 4.14)
        XCTAssertEqual(toPoints(mathConstants.fractionDenominatorDisplayStyleShiftDown), 8.232)
        XCTAssertEqual(toPoints(mathConstants.fractionNumeratorGapMin), ruleThickness)
        XCTAssertEqual(toPoints(mathConstants.fractionNumDisplayStyleGapMin), commonGap)
        XCTAssertEqual(toPoints(mathConstants.fractionRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(mathConstants.fractionDenominatorGapMin), ruleThickness)
        XCTAssertEqual(toPoints(mathConstants.fractionDenomDisplayStyleGapMin), commonGap)

        XCTAssertEqual(toPoints(mathConstants.skewedFractionHorizontalGap), 4.2)
        XCTAssertEqual(toPoints(mathConstants.skewedFractionVerticalGap), 1.152, accuracy: eps)

        XCTAssertEqual(toPoints(mathConstants.overbarVerticalGap), commonGap)
        XCTAssertEqual(toPoints(mathConstants.overbarRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(mathConstants.overbarExtraAscender), ruleThickness)

        XCTAssertEqual(toPoints(mathConstants.underbarVerticalGap), commonGap)
        XCTAssertEqual(toPoints(mathConstants.underbarRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(mathConstants.underbarExtraDescender), ruleThickness)

        XCTAssertEqual(toPoints(mathConstants.radicalVerticalGap), 0.6)
        XCTAssertEqual(toPoints(mathConstants.radicalDisplayStyleVerticalGap), 1.776)
        XCTAssertEqual(toPoints(mathConstants.radicalRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(mathConstants.radicalExtraAscender), ruleThickness)
        XCTAssertEqual(toPoints(mathConstants.radicalKernBeforeDegree), 3.336)
        XCTAssertEqual(toPoints(mathConstants.radicalKernAfterDegree), -6.672)

        XCTAssertEqual(toRatio(mathConstants.radicalDegreeBottomRaisePercent), 0.6)
    }

    func testMathItalicsCorrectionInfo() {
        var buf: unichar = 0
        var glyph: CGGlyph = 0

        ("f" as NSString).getCharacters(&buf, range: NSRange(location: 0, length: 1))
        CTFontGetGlyphsForCharacters(lmmath, &buf, &glyph, 1)

        let table = lmmath.mathTable!.mathGlyphInfoTable.mathItalicsCorrectionInfoTable
        let italicsCorrection = table.getItalicsCorrection(glyph)

        let toPoints = {(du: Int32) -> CGFloat in CGFloat(du) * self.lmmath.sizePerUnit()}

        print("\(toPoints(italicsCorrection))")
    }
}