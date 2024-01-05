import XCTest
@testable import SwiftOpenType

final class MathTableTests: XCTestCase {
    var lmmath: CTFont?

    override func setUp() async throws {
        lmmath = openFont(path: "fonts/latinmodern-math.otf", size: 12.0)
    }

    func testMathTableHeader() {
        let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
        XCTAssert(helvetica.mathTable == nil)

        XCTAssert(lmmath!.mathTable != nil)

        let mathTable = lmmath!.mathTable!
        XCTAssertEqual(mathTable.majorVersion(), 1)
        XCTAssertEqual(mathTable.minorVersion(), 0)
    }

    func testMathConstants() {
        let font = lmmath!
        let table = font.mathTable!.mathConstantsTable!

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
        let font = lmmath!
        let table = font.mathTable!.mathGlyphInfoTable!.mathItalicsCorrectionInfoTable!

        let glyph = CTFontGetGlyphWithName(font, "f" as CFString)
        let italicsCorrection = table.getItalicsCorrection(glyph)

        XCTAssertEqual(italicsCorrection, 79)
    }

    func testMathTopAccentAttachment() {
        let font = lmmath!
        let table = font.mathTable!.mathGlyphInfoTable!.mathTopAccentAttachmentTable!
        
        var glyph: CGGlyph
        
        glyph = CTFontGetGlyphWithName(font, "f" as CFString)
        XCTAssertEqual(table.getTopAccentAttachment(glyph), 262)
    }
    
    func testMathConstants_2() {
        let font = openFont(path: "fonts/MathTestFontFull.otf", size: 10.0)
        let table = font.mathTable!.mathConstantsTable!

        XCTAssertEqual(table.scriptPercentScaleDown, 87)
        XCTAssertEqual(table.scriptScriptPercentScaleDown, 76)
        XCTAssertEqual(table.delimitedSubFormulaMinHeight, 100)
        XCTAssertEqual(table.displayOperatorMinHeight, 200)
        XCTAssertEqual(table.mathLeading, 300)
        XCTAssertEqual(table.axisHeight, 400)
        XCTAssertEqual(table.accentBaseHeight, 500)
        XCTAssertEqual(table.flattenedAccentBaseHeight, 600)
        XCTAssertEqual(table.subscriptShiftDown, 700)
        XCTAssertEqual(table.subscriptTopMax, 800)
        XCTAssertEqual(table.subscriptBaselineDropMin, 900)
        XCTAssertEqual(table.superscriptShiftUp, 1100)
        XCTAssertEqual(table.superscriptShiftUpCramped, 1200)
        XCTAssertEqual(table.superscriptBottomMin, 1300)
        XCTAssertEqual(table.superscriptBaselineDropMax, 1400)
        XCTAssertEqual(table.subSuperscriptGapMin, 1500)
        XCTAssertEqual(table.superscriptBottomMaxWithSubscript, 1600)
        XCTAssertEqual(table.spaceAfterScript, 1700)
        XCTAssertEqual(table.upperLimitGapMin, 1800)
        XCTAssertEqual(table.upperLimitBaselineRiseMin, 1900)
        XCTAssertEqual(table.lowerLimitGapMin, 2200)
        XCTAssertEqual(table.lowerLimitBaselineDropMin, 2300)
        XCTAssertEqual(table.stackTopShiftUp, 2400)
        XCTAssertEqual(table.stackTopDisplayStyleShiftUp, 2500)
        XCTAssertEqual(table.stackBottomShiftDown, 2600)
        XCTAssertEqual(table.stackBottomDisplayStyleShiftDown, 2700)
        XCTAssertEqual(table.stackGapMin, 2800)
        XCTAssertEqual(table.stackDisplayStyleGapMin, 2900)
        XCTAssertEqual(table.stretchStackTopShiftUp, 3000)
        XCTAssertEqual(table.stretchStackBottomShiftDown, 3100)
        XCTAssertEqual(table.stretchStackGapAboveMin, 3200)
        XCTAssertEqual(table.stretchStackGapBelowMin, 3300)
        XCTAssertEqual(table.fractionNumeratorShiftUp, 3400)
        XCTAssertEqual(table.fractionNumeratorDisplayStyleShiftUp, 3500)
        XCTAssertEqual(table.fractionDenominatorShiftDown, 3600)
        XCTAssertEqual(table.fractionDenominatorDisplayStyleShiftDown, 3700)
        XCTAssertEqual(table.fractionNumeratorGapMin, 3800)
        XCTAssertEqual(table.fractionNumDisplayStyleGapMin, 3900)
        XCTAssertEqual(table.fractionRuleThickness, 4000)
        XCTAssertEqual(table.fractionDenominatorGapMin, 4100)
        XCTAssertEqual(table.fractionDenomDisplayStyleGapMin, 4200)
        XCTAssertEqual(table.skewedFractionHorizontalGap, 4300)
        XCTAssertEqual(table.skewedFractionVerticalGap, 4400)
        XCTAssertEqual(table.overbarVerticalGap, 4500)
        XCTAssertEqual(table.overbarRuleThickness, 4600)
        XCTAssertEqual(table.overbarExtraAscender, 4700)
        XCTAssertEqual(table.underbarVerticalGap, 4800)
        XCTAssertEqual(table.underbarRuleThickness, 4900)
        XCTAssertEqual(table.underbarExtraDescender, 5000)
        XCTAssertEqual(table.radicalVerticalGap, 5100)
        XCTAssertEqual(table.radicalDisplayStyleVerticalGap, 5200)
        XCTAssertEqual(table.radicalRuleThickness, 5300)
        XCTAssertEqual(table.radicalExtraAscender, 5400)
        XCTAssertEqual(table.radicalKernBeforeDegree, 5500)
        XCTAssertEqual(table.radicalKernAfterDegree, 5600)
        XCTAssertEqual(table.radicalDegreeBottomRaisePercent, 65)
    }

    func testMathItalicsCorrection_2() {
        let font = openFont(path: "fonts/MathTestFontFull.otf", size: 10.0)
        let table = font.mathTable!.mathGlyphInfoTable!.mathItalicsCorrectionInfoTable!

        var glyph: CGGlyph

        glyph = CTFontGetGlyphWithName(font, "space" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), nil)

        glyph = CTFontGetGlyphWithName(font, "A" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), 197)

        glyph = CTFontGetGlyphWithName(font, "B" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), 150)

        glyph = CTFontGetGlyphWithName(font, "C" as CFString)
        XCTAssertEqual(table.getItalicsCorrection(glyph), 452)
    }
    
    func testMathTopAccentAttachment_2() {
        let font = openFont(path: "fonts/MathTestFontFull.otf", size: 10.0)
        let table = font.mathTable!.mathGlyphInfoTable!.mathTopAccentAttachmentTable!
        
        var glyph: CGGlyph

        glyph = CTFontGetGlyphWithName(font, "space" as CFString)
        XCTAssertEqual(table.getTopAccentAttachment(glyph), nil)
        
        var advance: CGSize = CGSize()
        CTFontGetAdvancesForGlyphs(font, CTFontOrientation.default, &glyph, &advance, 1)
        let topAccentAttachment = advance.width / font.sizePerUnit() * 0.5
        XCTAssertEqual(topAccentAttachment, 500)

        glyph = CTFontGetGlyphWithName(font, "D" as CFString)
        XCTAssertEqual(table.getTopAccentAttachment(glyph), 374)

        glyph = CTFontGetGlyphWithName(font, "E" as CFString)
        XCTAssertEqual(table.getTopAccentAttachment(glyph), 346)

        glyph = CTFontGetGlyphWithName(font, "F" as CFString)
        XCTAssertEqual(table.getTopAccentAttachment(glyph), 318)
    }
    
    func testMathExtendedShape_2() {
        let font = openFont(path: "fonts/MathTestFontFull.otf", size: 10.0)
        let table = font.mathTable!.mathGlyphInfoTable!.extendedShapeCoverageTable
        
        var glyph: CGGlyph
        
        glyph = CTFontGetGlyphWithName(font, "G" as CFString)
        XCTAssert(table?.getCoverageIndex(glyph) == nil)
        
        glyph = CTFontGetGlyphWithName(font, "H" as CFString)
        XCTAssert(table?.getCoverageIndex(glyph) != nil)
    }
        
    func openFont(path : String, size: CGFloat) -> CTFont {
        let resourcePath = Bundle.module.resourcePath!
        let path = resourcePath + "/" + path

        let fileURL = URL(filePath: path)
        let fontDesc = CTFontManagerCreateFontDescriptorsFromURL(fileURL as CFURL) as! [CTFontDescriptor]
        return CTFontCreateWithFontDescriptor(fontDesc[0], size, nil)
    }
}
