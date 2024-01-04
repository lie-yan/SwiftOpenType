import XCTest
@testable import SwiftOpenType

final class MathTableTests: XCTestCase {

    let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
    let lmmath = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)

    func testMathTableHeader() {
        XCTAssert(helvetica.mathTable == nil)

        XCTAssert(lmmath.mathTable != nil)

        let mathTable = lmmath.mathTable!
        XCTAssertEqual(mathTable.majorVersion(), 1)
        XCTAssertEqual(mathTable.minorVersion(), 0)
    }

    func testMathConstants() {
        let font = lmmath
        let table = lmmath.mathTable!.mathConstantsTable!

        let ruleThickness: CGFloat = 0.48
        let commonGap: CGFloat = 1.44
        let eps: CGFloat = 1e-15

        let toRatio = {(p: Int32) -> CGFloat in CGFloat(p) / 100}
        let toPoints = {(du: Int32) -> CGFloat in CGFloat(du) * font.sizePerUnit()}

        XCTAssertEqual(toRatio(table.scriptPercentScaleDown), 0.7)
        XCTAssertEqual(toRatio(table.scriptScriptPercentScaleDown), 0.5)

        XCTAssertEqual(toPoints(table.delimitedSubFormulaMinHeight), 15.6)
        XCTAssertEqual(toPoints(table.displayOperatorMinHeight), 15.6)

        XCTAssertEqual(toPoints(table.mathLeading), 1.848)
        XCTAssertEqual(toPoints(table.axisHeight), 3.0)
        XCTAssertEqual(toPoints(table.accentBaseHeight), 5.4)
        XCTAssertEqual(toPoints(table.flattenedAccentBaseHeight), 7.968)

        XCTAssertEqual(toPoints(table.subscriptShiftDown), 2.964)
        XCTAssertEqual(toPoints(table.subscriptTopMax), 4.128)
        XCTAssertEqual(toPoints(table.subscriptBaselineDropMin), 2.4)
        XCTAssertEqual(toPoints(table.superscriptShiftUp), 4.356)
        XCTAssertEqual(toPoints(table.superscriptShiftUpCramped), 3.468)
        XCTAssertEqual(toPoints(table.superscriptBottomMin), 1.296)
        XCTAssertEqual(toPoints(table.superscriptBaselineDropMax), 3.0)
        XCTAssertEqual(toPoints(table.subSuperscriptGapMin), 1.92)
        XCTAssertEqual(toPoints(table.superscriptBottomMaxWithSubscript), 4.128)
        XCTAssertEqual(toPoints(table.spaceAfterScript), 0.672)

        XCTAssertEqual(toPoints(table.upperLimitGapMin), 2.4)
        XCTAssertEqual(toPoints(table.upperLimitBaselineRiseMin), 1.332)
        XCTAssertEqual(toPoints(table.lowerLimitGapMin), 2.004)
        XCTAssertEqual(toPoints(table.lowerLimitBaselineDropMin), 7.2)

        XCTAssertEqual(toPoints(table.stackTopShiftUp), 5.328)
        XCTAssertEqual(toPoints(table.stackTopDisplayStyleShiftUp), 8.124)
        XCTAssertEqual(toPoints(table.stackBottomShiftDown), 4.14)
        XCTAssertEqual(toPoints(table.stackBottomDisplayStyleShiftDown), 8.232)
        XCTAssertEqual(toPoints(table.stackGapMin), 1.44)
        XCTAssertEqual(toPoints(table.stackDisplayStyleGapMin), 3.36)

        XCTAssertEqual(toPoints(table.stretchStackTopShiftUp), 1.332)
        XCTAssertEqual(toPoints(table.stretchStackBottomShiftDown), 7.2)
        XCTAssertEqual(toPoints(table.stretchStackGapAboveMin), 2.4)
        XCTAssertEqual(toPoints(table.stretchStackGapBelowMin), 2.004)

        XCTAssertEqual(toPoints(table.fractionNumeratorShiftUp), 4.728)
        XCTAssertEqual(toPoints(table.fractionNumeratorDisplayStyleShiftUp), 8.124)
        XCTAssertEqual(toPoints(table.fractionDenominatorShiftDown), 4.14)
        XCTAssertEqual(toPoints(table.fractionDenominatorDisplayStyleShiftDown), 8.232)
        XCTAssertEqual(toPoints(table.fractionNumeratorGapMin), ruleThickness)
        XCTAssertEqual(toPoints(table.fractionNumDisplayStyleGapMin), commonGap)
        XCTAssertEqual(toPoints(table.fractionRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(table.fractionDenominatorGapMin), ruleThickness)
        XCTAssertEqual(toPoints(table.fractionDenomDisplayStyleGapMin), commonGap)

        XCTAssertEqual(toPoints(table.skewedFractionHorizontalGap), 4.2)
        XCTAssertEqual(toPoints(table.skewedFractionVerticalGap), 1.152, accuracy: eps)

        XCTAssertEqual(toPoints(table.overbarVerticalGap), commonGap)
        XCTAssertEqual(toPoints(table.overbarRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(table.overbarExtraAscender), ruleThickness)

        XCTAssertEqual(toPoints(table.underbarVerticalGap), commonGap)
        XCTAssertEqual(toPoints(table.underbarRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(table.underbarExtraDescender), ruleThickness)

        XCTAssertEqual(toPoints(table.radicalVerticalGap), 0.6)
        XCTAssertEqual(toPoints(table.radicalDisplayStyleVerticalGap), 1.776)
        XCTAssertEqual(toPoints(table.radicalRuleThickness), ruleThickness)
        XCTAssertEqual(toPoints(table.radicalExtraAscender), ruleThickness)
        XCTAssertEqual(toPoints(table.radicalKernBeforeDegree), 3.336)
        XCTAssertEqual(toPoints(table.radicalKernAfterDegree), -6.672)

        XCTAssertEqual(toRatio(table.radicalDegreeBottomRaisePercent), 0.6)
    }

    func testMathItalicsCorrection() {
        let font = lmmath
        let table = font.mathTable!.mathGlyphInfoTable!.mathItalicsCorrectionInfoTable!

        let glyph = CTFontGetGlyphWithName(font, "f" as CFString)
        let italicsCorrection = table.getItalicsCorrection(glyph)

        XCTAssertEqual(italicsCorrection, 79)
    }

    func testMathTopAccentAttachment() {
        let font = lmmath
        let table = lmmath.mathTable!.mathGlyphInfoTable!.mathTopAccentAttachmentTable!
        
        var glyph: CGGlyph
        
        glyph = CTFontGetGlyphWithName(font, "f" as CFString)
        XCTAssertEqual(table.getTopAccentAttachment(glyph), 262)
    }

    func testMathItalicsCorrection_2() {
        let font = openFont(path: "fonts/MathTestFontFull.otf", size: 10.0)
        let table = font.mathTable!.mathGlyphInfoTable!.mathItalicsCorrectionInfoTable!

        var glyph: CGGlyph

        glyph = CTFontGetGlyphWithName(font, "space" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), 0)

        glyph = CTFontGetGlyphWithName(font, "A" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), 197)

        glyph = CTFontGetGlyphWithName(font, "B" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), 150)

        glyph = CTFontGetGlyphWithName(font, "C" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), 452)
    }
        
    func openFont(path : String, size: CGFloat) -> CTFont {
        let resourcePath = Bundle.module.resourcePath!
        let path = resourcePath + "/" + path

        let fileURL = URL(filePath: path)
        let fontDesc = CTFontManagerCreateFontDescriptorsFromURL(fileURL as CFURL) as! [CTFontDescriptor]
        return CTFontCreateWithFontDescriptor(fontDesc[0], size, nil)
    }
}
