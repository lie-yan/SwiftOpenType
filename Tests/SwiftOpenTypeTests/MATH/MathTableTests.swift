@testable import SwiftOpenType
import XCTest

/// - See also:
///     [test-ot-math.c](https://github.com/harfbuzz/harfbuzz/blob/main/test/api/test-ot-math.c) of
///     [harfbuzz](https://github.com/harfbuzz/harfbuzz)
final class MathTableTests: XCTestCase {
    func testHasData() {
        do {
            let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
            let mathData = helvetica.createCachedMathData()
            XCTAssertFalse(mathData.hasData())
        }

        do {
            let lmmath = openCTFont("fonts/latinmodern-math.otf", 12)
            let mathData = lmmath.createCachedMathData()
            XCTAssertTrue(mathData.hasData())
        }
    }

    func testMathConstants() {
        let lmmath = openCTFont("fonts/latinmodern-math.otf", 12)
        let mathData = lmmath.createCachedMathData()
        XCTAssertTrue(mathData.hasData())

        let ruleThickness: CGFloat = 0.48
        let commonGap: CGFloat = 1.44
        let eps: CGFloat = 1e-15

        XCTAssertEqual(mathData.scriptPercentScaleDown(), 0.7)
        XCTAssertEqual(mathData.scriptScriptPercentScaleDown(), 0.5)
        XCTAssertEqual(mathData.delimitedSubFormulaMinHeight(), 15.6)
        XCTAssertEqual(mathData.displayOperatorMinHeight(), 15.6)
        XCTAssertEqual(mathData.mathLeading(), 1.848)
        XCTAssertEqual(mathData.axisHeight(), 3.0)
        XCTAssertEqual(mathData.accentBaseHeight(), 5.4)
        XCTAssertEqual(mathData.flattenedAccentBaseHeight(), 7.968)
        XCTAssertEqual(mathData.subscriptShiftDown(), 2.964)
        XCTAssertEqual(mathData.subscriptTopMax(), 4.128)
        XCTAssertEqual(mathData.subscriptBaselineDropMin(), 2.4)
        XCTAssertEqual(mathData.superscriptShiftUp(), 4.356)
        XCTAssertEqual(mathData.superscriptShiftUpCramped(), 3.468)
        XCTAssertEqual(mathData.superscriptBottomMin(), 1.296)
        XCTAssertEqual(mathData.superscriptBaselineDropMax(), 3.0)
        XCTAssertEqual(mathData.subSuperscriptGapMin(), 1.92)
        XCTAssertEqual(mathData.superscriptBottomMaxWithSubscript(), 4.128)
        XCTAssertEqual(mathData.spaceAfterScript(), 0.672)
        XCTAssertEqual(mathData.upperLimitGapMin(), 2.4)
        XCTAssertEqual(mathData.upperLimitBaselineRiseMin(), 1.332)
        XCTAssertEqual(mathData.lowerLimitGapMin(), 2.004)
        XCTAssertEqual(mathData.lowerLimitBaselineDropMin(), 7.2)
        XCTAssertEqual(mathData.stackTopShiftUp(), 5.328)
        XCTAssertEqual(mathData.stackTopDisplayStyleShiftUp(), 8.124)
        XCTAssertEqual(mathData.stackBottomShiftDown(), 4.14)
        XCTAssertEqual(mathData.stackBottomDisplayStyleShiftDown(), 8.232)
        XCTAssertEqual(mathData.stackGapMin(), 1.44)
        XCTAssertEqual(mathData.stackDisplayStyleGapMin(), 3.36)
        XCTAssertEqual(mathData.stretchStackTopShiftUp(), 1.332)
        XCTAssertEqual(mathData.stretchStackBottomShiftDown(), 7.2)
        XCTAssertEqual(mathData.stretchStackGapAboveMin(), 2.4)
        XCTAssertEqual(mathData.stretchStackGapBelowMin(), 2.004)
        XCTAssertEqual(mathData.fractionNumeratorShiftUp(), 4.728)
        XCTAssertEqual(mathData.fractionNumeratorDisplayStyleShiftUp(), 8.124)
        XCTAssertEqual(mathData.fractionDenominatorShiftDown(), 4.14)
        XCTAssertEqual(mathData.fractionDenominatorDisplayStyleShiftDown(), 8.232)
        XCTAssertEqual(mathData.fractionNumeratorGapMin(), ruleThickness)
        XCTAssertEqual(mathData.fractionNumDisplayStyleGapMin(), commonGap)
        XCTAssertEqual(mathData.fractionRuleThickness(), ruleThickness)
        XCTAssertEqual(mathData.fractionDenominatorGapMin(), ruleThickness)
        XCTAssertEqual(mathData.fractionDenomDisplayStyleGapMin(), commonGap)
        XCTAssertEqual(mathData.skewedFractionHorizontalGap(), 4.2)
        XCTAssertEqual(mathData.skewedFractionVerticalGap(), 1.152, accuracy: eps)
        XCTAssertEqual(mathData.overbarVerticalGap(), commonGap)
        XCTAssertEqual(mathData.overbarRuleThickness(), ruleThickness)
        XCTAssertEqual(mathData.overbarExtraAscender(), ruleThickness)
        XCTAssertEqual(mathData.underbarVerticalGap(), commonGap)
        XCTAssertEqual(mathData.underbarRuleThickness(), ruleThickness)
        XCTAssertEqual(mathData.underbarExtraDescender(), ruleThickness)
        XCTAssertEqual(mathData.radicalVerticalGap(), 0.6)
        XCTAssertEqual(mathData.radicalDisplayStyleVerticalGap(), 1.776)
        XCTAssertEqual(mathData.radicalRuleThickness(), ruleThickness)
        XCTAssertEqual(mathData.radicalExtraAscender(), ruleThickness)
        XCTAssertEqual(mathData.radicalKernBeforeDegree(), 3.336)
        XCTAssertEqual(mathData.radicalKernAfterDegree(), -6.672)
        XCTAssertEqual(mathData.radicalDegreeBottomRaisePercent(), 0.6)

        XCTAssertEqual(mathData.getConstant(.scriptPercentScaleDown), mathData.scriptPercentScaleDown())
        XCTAssertEqual(mathData.getConstant(.scriptScriptPercentScaleDown), mathData.scriptScriptPercentScaleDown())
        XCTAssertEqual(mathData.getConstant(.delimitedSubFormulaMinHeight), mathData.delimitedSubFormulaMinHeight())
        XCTAssertEqual(mathData.getConstant(.displayOperatorMinHeight), mathData.displayOperatorMinHeight())
        XCTAssertEqual(mathData.getConstant(.mathLeading), mathData.mathLeading())
        XCTAssertEqual(mathData.getConstant(.axisHeight), mathData.axisHeight())
        XCTAssertEqual(mathData.getConstant(.accentBaseHeight), mathData.accentBaseHeight())
        XCTAssertEqual(mathData.getConstant(.flattenedAccentBaseHeight), mathData.flattenedAccentBaseHeight())
        XCTAssertEqual(mathData.getConstant(.subscriptShiftDown), mathData.subscriptShiftDown())
        XCTAssertEqual(mathData.getConstant(.subscriptTopMax), mathData.subscriptTopMax())
        XCTAssertEqual(mathData.getConstant(.subscriptBaselineDropMin), mathData.subscriptBaselineDropMin())
        XCTAssertEqual(mathData.getConstant(.superscriptShiftUp), mathData.superscriptShiftUp())
        XCTAssertEqual(mathData.getConstant(.superscriptShiftUpCramped), mathData.superscriptShiftUpCramped())
        XCTAssertEqual(mathData.getConstant(.superscriptBottomMin), mathData.superscriptBottomMin())
        XCTAssertEqual(mathData.getConstant(.superscriptBaselineDropMax), mathData.superscriptBaselineDropMax())
        XCTAssertEqual(mathData.getConstant(.subSuperscriptGapMin), mathData.subSuperscriptGapMin())
        XCTAssertEqual(mathData.getConstant(.superscriptBottomMaxWithSubscript), mathData.superscriptBottomMaxWithSubscript())
        XCTAssertEqual(mathData.getConstant(.spaceAfterScript), mathData.spaceAfterScript())
        XCTAssertEqual(mathData.getConstant(.upperLimitGapMin), mathData.upperLimitGapMin())
        XCTAssertEqual(mathData.getConstant(.upperLimitBaselineRiseMin), mathData.upperLimitBaselineRiseMin())
        XCTAssertEqual(mathData.getConstant(.lowerLimitGapMin), mathData.lowerLimitGapMin())
        XCTAssertEqual(mathData.getConstant(.lowerLimitBaselineDropMin), mathData.lowerLimitBaselineDropMin())
        XCTAssertEqual(mathData.getConstant(.stackTopShiftUp), mathData.stackTopShiftUp())
        XCTAssertEqual(mathData.getConstant(.stackTopDisplayStyleShiftUp), mathData.stackTopDisplayStyleShiftUp())
        XCTAssertEqual(mathData.getConstant(.stackBottomShiftDown), mathData.stackBottomShiftDown())
        XCTAssertEqual(mathData.getConstant(.stackBottomDisplayStyleShiftDown), mathData.stackBottomDisplayStyleShiftDown())
        XCTAssertEqual(mathData.getConstant(.stackGapMin), mathData.stackGapMin())
        XCTAssertEqual(mathData.getConstant(.stackDisplayStyleGapMin), mathData.stackDisplayStyleGapMin())
        XCTAssertEqual(mathData.getConstant(.stretchStackTopShiftUp), mathData.stretchStackTopShiftUp())
        XCTAssertEqual(mathData.getConstant(.stretchStackBottomShiftDown), mathData.stretchStackBottomShiftDown())
        XCTAssertEqual(mathData.getConstant(.stretchStackGapAboveMin), mathData.stretchStackGapAboveMin())
        XCTAssertEqual(mathData.getConstant(.stretchStackGapBelowMin), mathData.stretchStackGapBelowMin())
        XCTAssertEqual(mathData.getConstant(.fractionNumeratorShiftUp), mathData.fractionNumeratorShiftUp())
        XCTAssertEqual(mathData.getConstant(.fractionNumeratorDisplayStyleShiftUp), mathData.fractionNumeratorDisplayStyleShiftUp())
        XCTAssertEqual(mathData.getConstant(.fractionDenominatorShiftDown), mathData.fractionDenominatorShiftDown())
        XCTAssertEqual(mathData.getConstant(.fractionDenominatorDisplayStyleShiftDown), mathData.fractionDenominatorDisplayStyleShiftDown())
        XCTAssertEqual(mathData.getConstant(.fractionNumeratorGapMin), mathData.fractionNumeratorGapMin())
        XCTAssertEqual(mathData.getConstant(.fractionNumDisplayStyleGapMin), mathData.fractionNumDisplayStyleGapMin())
        XCTAssertEqual(mathData.getConstant(.fractionRuleThickness), mathData.fractionRuleThickness())
        XCTAssertEqual(mathData.getConstant(.fractionDenominatorGapMin), mathData.fractionDenominatorGapMin())
        XCTAssertEqual(mathData.getConstant(.fractionDenomDisplayStyleGapMin), mathData.fractionDenomDisplayStyleGapMin())
        XCTAssertEqual(mathData.getConstant(.skewedFractionHorizontalGap), mathData.skewedFractionHorizontalGap())
        XCTAssertEqual(mathData.getConstant(.skewedFractionVerticalGap), mathData.skewedFractionVerticalGap())
        XCTAssertEqual(mathData.getConstant(.overbarVerticalGap), mathData.overbarVerticalGap())
        XCTAssertEqual(mathData.getConstant(.overbarRuleThickness), mathData.overbarRuleThickness())
        XCTAssertEqual(mathData.getConstant(.overbarExtraAscender), mathData.overbarExtraAscender())
        XCTAssertEqual(mathData.getConstant(.underbarVerticalGap), mathData.underbarVerticalGap())
        XCTAssertEqual(mathData.getConstant(.underbarRuleThickness), mathData.underbarRuleThickness())
        XCTAssertEqual(mathData.getConstant(.underbarExtraDescender), mathData.underbarExtraDescender())
        XCTAssertEqual(mathData.getConstant(.radicalVerticalGap), mathData.radicalVerticalGap())
        XCTAssertEqual(mathData.getConstant(.radicalDisplayStyleVerticalGap), mathData.radicalDisplayStyleVerticalGap())
        XCTAssertEqual(mathData.getConstant(.radicalRuleThickness), mathData.radicalRuleThickness())
        XCTAssertEqual(mathData.getConstant(.radicalExtraAscender), mathData.radicalExtraAscender())
        XCTAssertEqual(mathData.getConstant(.radicalKernBeforeDegree), mathData.radicalKernBeforeDegree())
        XCTAssertEqual(mathData.getConstant(.radicalKernAfterDegree), mathData.radicalKernAfterDegree())
        XCTAssertEqual(mathData.getConstant(.radicalDegreeBottomRaisePercent), mathData.radicalDegreeBottomRaisePercent())
    }

    func testMathConstants_2() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10.0)
            let mathData = font.createCachedMathData()
            XCTAssert(mathData.getConstant(.axisHeight) == 0) // MathConstants not available
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10.0)
            let pts = font.toPointsClosure()
            let mathData = font.createCachedMathData()

            XCTAssertEqual(mathData.scriptPercentScaleDown(), pts(87))
            XCTAssertEqual(mathData.scriptScriptPercentScaleDown(), pts(76))
            XCTAssertEqual(mathData.delimitedSubFormulaMinHeight(), pts(100))
            XCTAssertEqual(mathData.displayOperatorMinHeight(), pts(200))
            XCTAssertEqual(mathData.mathLeading(), pts(300))
            XCTAssertEqual(mathData.axisHeight(), pts(400))
            XCTAssertEqual(mathData.accentBaseHeight(), pts(500))
            XCTAssertEqual(mathData.flattenedAccentBaseHeight(), pts(600))
            XCTAssertEqual(mathData.subscriptShiftDown(), pts(700))
            XCTAssertEqual(mathData.subscriptTopMax(), pts(800))
            XCTAssertEqual(mathData.subscriptBaselineDropMin(), pts(900))
            XCTAssertEqual(mathData.superscriptShiftUp(), pts(1100))
            XCTAssertEqual(mathData.superscriptShiftUpCramped(), pts(1200))
            XCTAssertEqual(mathData.superscriptBottomMin(), pts(1300))
            XCTAssertEqual(mathData.superscriptBaselineDropMax(), pts(1400))
            XCTAssertEqual(mathData.subSuperscriptGapMin(), pts(1500))
            XCTAssertEqual(mathData.superscriptBottomMaxWithSubscript(), pts(1600))
            XCTAssertEqual(mathData.spaceAfterScript(), pts(1700))
            XCTAssertEqual(mathData.upperLimitGapMin(), pts(1800))
            XCTAssertEqual(mathData.upperLimitBaselineRiseMin(), pts(1900))
            XCTAssertEqual(mathData.lowerLimitGapMin(), pts(2200))
            XCTAssertEqual(mathData.lowerLimitBaselineDropMin(), pts(2300))
            XCTAssertEqual(mathData.stackTopShiftUp(), pts(2400))
            XCTAssertEqual(mathData.stackTopDisplayStyleShiftUp(), pts(2500))
            XCTAssertEqual(mathData.stackBottomShiftDown(), pts(2600))
            XCTAssertEqual(mathData.stackBottomDisplayStyleShiftDown(), pts(2700))
            XCTAssertEqual(mathData.stackGapMin(), pts(2800))
            XCTAssertEqual(mathData.stackDisplayStyleGapMin(), pts(2900))
            XCTAssertEqual(mathData.stretchStackTopShiftUp(), pts(3000))
            XCTAssertEqual(mathData.stretchStackBottomShiftDown(), pts(3100))
            XCTAssertEqual(mathData.stretchStackGapAboveMin(), pts(3200))
            XCTAssertEqual(mathData.stretchStackGapBelowMin(), pts(3300))
            XCTAssertEqual(mathData.fractionNumeratorShiftUp(), pts(3400))
            XCTAssertEqual(mathData.fractionNumeratorDisplayStyleShiftUp(), pts(3500))
            XCTAssertEqual(mathData.fractionDenominatorShiftDown(), pts(3600))
            XCTAssertEqual(mathData.fractionDenominatorDisplayStyleShiftDown(), pts(3700))
            XCTAssertEqual(mathData.fractionNumeratorGapMin(), pts(3800))
            XCTAssertEqual(mathData.fractionNumDisplayStyleGapMin(), pts(3900))
            XCTAssertEqual(mathData.fractionRuleThickness(), pts(4000))
            XCTAssertEqual(mathData.fractionDenominatorGapMin(), pts(4100))
            XCTAssertEqual(mathData.fractionDenomDisplayStyleGapMin(), pts(4200))
            XCTAssertEqual(mathData.skewedFractionHorizontalGap(), pts(4300))
            XCTAssertEqual(mathData.skewedFractionVerticalGap(), pts(4400))
            XCTAssertEqual(mathData.overbarVerticalGap(), pts(4500))
            XCTAssertEqual(mathData.overbarRuleThickness(), pts(4600))
            XCTAssertEqual(mathData.overbarExtraAscender(), pts(4700))
            XCTAssertEqual(mathData.underbarVerticalGap(), pts(4800))
            XCTAssertEqual(mathData.underbarRuleThickness(), pts(4900))
            XCTAssertEqual(mathData.underbarExtraDescender(), pts(5000))
            XCTAssertEqual(mathData.radicalVerticalGap(), pts(5100))
            XCTAssertEqual(mathData.radicalDisplayStyleVerticalGap(), pts(5200))
            XCTAssertEqual(mathData.radicalRuleThickness(), pts(5300))
            XCTAssertEqual(mathData.radicalExtraAscender(), pts(5400))
            XCTAssertEqual(mathData.radicalKernBeforeDegree(), pts(5500))
            XCTAssertEqual(mathData.radicalKernAfterDegree(), pts(5600))
            XCTAssertEqual(mathData.radicalDegreeBottomRaisePercent(), pts(65))
        }
    }

    func testMathItalicsCorrection() {
        let font = openCTFont("fonts/latinmodern-math.otf", 12)
        let pts = font.toPointsClosure()
        let glyph = font.getGlyphWithName("f")

        let mathData = font.createCachedMathData()
        XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), pts(79))
    }

    func testMathItalicsCorrection_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathData = font.createCachedMathData()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), 0)
        }

        // MathGlyphInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathData = font.createCachedMathData()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), 0)
        }

        // MathItalicsCorrectionInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let mathData = font.createCachedMathData()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let pts = font.toPointsClosure()
            let mathData = font.createCachedMathData()

            var glyph: CGGlyph

            glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), 0) // Glyph without italic correction.

            glyph = font.getGlyphWithName("A")
            XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), pts(197))

            glyph = font.getGlyphWithName("B")
            XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), pts(150))

            glyph = font.getGlyphWithName("C")
            XCTAssertEqual(mathData.getGlyphItalicsCorrection(glyph), pts(452))
        }
    }

    func testMathTopAccentAttachment() {
        let font = openCTFont("fonts/latinmodern-math.otf", 12)
        let pts = font.toPointsClosure()
        let mathData = font.createCachedMathData()

        let glyph = font.getGlyphWithName("f")
        XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(262))
    }

    func testMathTopAccentAttachment_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let pts = font.toPointsClosure()
            let mathData = font.createCachedMathData()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(500))
        }

        // MathGlyphInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let pts = font.toPointsClosure()
            let mathData = font.createCachedMathData()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(500))
        }

        // MathTopAccentAttachment empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let pts = font.toPointsClosure()
            let mathData = font.createCachedMathData()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(500))
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let pts = font.toPointsClosure()
            let mathData = font.createCachedMathData()

            var glyph: CGGlyph

            glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(500))

            glyph = font.getGlyphWithName("D")
            XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(374))

            glyph = font.getGlyphWithName("E")
            XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(346))

            glyph = font.getGlyphWithName("F")
            XCTAssertEqual(mathData.getGlyphTopAccentAttachment(glyph), pts(318))
        }
    }

    func testMathExtendedShape_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathData = font.createCachedMathData()
            XCTAssertFalse(mathData.isGlyphExtendedShape(glyph))
        }

        // MathGlyphInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathData = font.createCachedMathData()
            XCTAssertFalse(mathData.isGlyphExtendedShape(glyph))
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathData = font.createCachedMathData()

            var glyph: CGGlyph

            glyph = font.getGlyphWithName("G")
            XCTAssertFalse(mathData.isGlyphExtendedShape(glyph))

            glyph = font.getGlyphWithName("H")
            XCTAssert(mathData.isGlyphExtendedShape(glyph))
        }
    }

    func testMathKernInfo_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathData = font.createCachedMathData()
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        // MathKernInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathData = font.createCachedMathData()
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        // MathKernInfoRecords empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathData = font.createCachedMathData()
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("I")
            let pts = font.toPointsClosure()

            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(7)), pts(31)) // less than min height
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(14)), pts(52)) // equal to min height
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(20)), pts(52))
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(23)), pts(73))
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(31)), pts(73))
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(32)), pts(94))
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(86)), pts(220)) // equal to max height
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(91)), pts(220)) // larger than max height
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(96)), pts(220)) // larger than max height

            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopRight, pts(39)), pts(94)) // top right
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .TopLeft, pts(39)), pts(55)) // top left
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomRight, pts(39)), pts(22)) // bottom right
            XCTAssertEqual(mathData.getGlyphKerning(glyph, .BottomLeft, pts(39)), pts(50)) // bottom left
        }
    }

    func testGetGlyphKernings() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let glyph = font.getGlyphWithName("space")

            let mathData = font.createCachedMathData()
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopRight), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopLeft), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomRight), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomLeft), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let glyph = font.getGlyphWithName("space")

            let mathData = font.createCachedMathData()
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopRight), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopLeft), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomRight), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomLeft), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let glyph = font.getGlyphWithName("space")

            let mathData = font.createCachedMathData()
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopRight), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopLeft), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomRight), 0)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomLeft), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10.0)
            let glyph = font.getGlyphWithName("I")
            let pts = font.toPointsClosure()

            let mathData = font.createCachedMathData()

            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopRight, 0), 10)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .TopLeft, 0), 3)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomRight, 0), 9)
            XCTAssertEqual(mathData.getGlyphKerningCount(glyph, .BottomLeft, 0), 7)

            let entriesCount = 20
            var entries = [MathKernEntry](repeating: .init(), count: entriesCount)

            // case 1
            var count = entries.count
            XCTAssertEqual(mathData.getGlyphKernings(glyph, .TopRight, 0, &count, &entries), 10)
            XCTAssertEqual(count, 10)
            XCTAssertEqual(entries[0].maxCorrectionHeight, pts(14))
            XCTAssertEqual(entries[0].kernValue, pts(31))
            XCTAssertEqual(entries[1].maxCorrectionHeight, pts(23))
            XCTAssertEqual(entries[1].kernValue, pts(52))
            XCTAssertEqual(entries[2].maxCorrectionHeight, pts(32))
            XCTAssertEqual(entries[2].kernValue, pts(73))
            XCTAssertEqual(entries[3].maxCorrectionHeight, pts(41))
            XCTAssertEqual(entries[3].kernValue, pts(94))
            XCTAssertEqual(entries[4].maxCorrectionHeight, pts(50))
            XCTAssertEqual(entries[4].kernValue, pts(115))
            XCTAssertEqual(entries[5].maxCorrectionHeight, pts(59))
            XCTAssertEqual(entries[5].kernValue, pts(136))
            XCTAssertEqual(entries[6].maxCorrectionHeight, pts(68))
            XCTAssertEqual(entries[6].kernValue, pts(157))
            XCTAssertEqual(entries[7].maxCorrectionHeight, pts(77))
            XCTAssertEqual(entries[7].kernValue, pts(178))
            XCTAssertEqual(entries[8].maxCorrectionHeight, pts(86))
            XCTAssertEqual(entries[8].kernValue, pts(199))
            XCTAssertEqual(entries[9].maxCorrectionHeight, CGFloat.infinity)
            XCTAssertEqual(entries[9].kernValue, pts(220))

            // case 2
            count = entries.count
            XCTAssertEqual(mathData.getGlyphKernings(glyph, .TopLeft, 0, &count, &entries), 3)
            XCTAssertEqual(count, 3)
            XCTAssertEqual(entries[0].maxCorrectionHeight, pts(20))
            XCTAssertEqual(entries[0].kernValue, pts(25))
            XCTAssertEqual(entries[1].maxCorrectionHeight, pts(35))
            XCTAssertEqual(entries[1].kernValue, pts(40))
            XCTAssertEqual(entries[2].maxCorrectionHeight, CGFloat.infinity)
            XCTAssertEqual(entries[2].kernValue, pts(55))
        }
    }

    func testGetGlyphVariants() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial4.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathData = font.createCachedMathData()

            let pts = font.toPointsClosure()

            let variantsSize = 20
            var variants = [MathGlyphVariant](repeating: .init(), count: variantsSize)
            var count = 0
            var offset = 0

            var glyph = font.getGlyphWithName("arrowleft")
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .BTT), 0)
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .RTL), 3)

            glyph = font.getGlyphWithName("arrowup")
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .BTT), 4)
            XCTAssertEqual(mathData.getGlyphVariantCount(glyph, .RTL), 0)

            glyph = font.getGlyphWithName("arrowleft")
            offset = 0
            repeat {
                count = variantsSize
                mathData.getGlyphVariants(glyph, .RTL, offset, &count, &variants)
                offset += count
            } while count == variantsSize
            XCTAssertEqual(offset, 3)
            XCTAssertEqual(variants[0].glyph, font.getGlyphWithName("uni2190_size2"))
            XCTAssertEqual(variants[0].advance, pts(2151))
            XCTAssertEqual(variants[1].glyph, font.getGlyphWithName("uni2190_size3"))
            XCTAssertEqual(variants[1].advance, pts(2401))
            XCTAssertEqual(variants[2].glyph, font.getGlyphWithName("uni2190_size4"))
            XCTAssertEqual(variants[2].advance, pts(2901))

            glyph = font.getGlyphWithName("arrowup")
            offset = 0
            repeat {
                count = variantsSize
                mathData.getGlyphVariants(glyph, .BTT, offset, &count, &variants)
                offset += count
            } while count == variantsSize
            XCTAssertEqual(offset, 4)
            XCTAssertEqual(variants[0].glyph, font.getGlyphWithName("uni2191_size2"))
            XCTAssertEqual(variants[0].advance, pts(2251))
            XCTAssertEqual(variants[1].glyph, font.getGlyphWithName("uni2191_size3"))
            XCTAssertEqual(variants[1].advance, pts(2501))
            XCTAssertEqual(variants[2].glyph, font.getGlyphWithName("uni2191_size4"))
            XCTAssertEqual(variants[2].advance, pts(3001))
            XCTAssertEqual(variants[3].glyph, font.getGlyphWithName("uni2191_size5"))
            XCTAssertEqual(variants[3].advance, pts(3751))
        }
    }

    func testGetMinConnectorOverlap() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathData = font.createCachedMathData()

            XCTAssertEqual(mathData.getMinConnectorOverlap(.LTR), 0)
            XCTAssertEqual(mathData.getMinConnectorOverlap(.TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathData = font.createCachedMathData()

            let pts = font.toPointsClosure()
            XCTAssertEqual(mathData.getMinConnectorOverlap(.LTR), pts(54))
            XCTAssertEqual(mathData.getMinConnectorOverlap(.TTB), pts(54))
        }
    }

    func testGetGlyphAssembly() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .BTT), 0)
            
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial4.otf", 10)
            let mathData = font.createCachedMathData()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathData = font.createCachedMathData()

            let pts = font.toPointsClosure()

            let partsSize = 20
            var parts = [GlyphPart](repeating: .init(), count: partsSize)
            var count = 0
            var itCorr: CGFloat = 0
            var offset = 0

            var glyph = font.getGlyphWithName("arrowleft")
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .LTR), pts(124))
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)

            glyph = font.getGlyphWithName("arrowup")
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyItalicsCorrection(glyph, .TTB), pts(331))

            glyph = font.getGlyphWithName("arrowright")
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .BTT), 0)
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .RTL), 3)

            glyph = font.getGlyphWithName("arrowdown")
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .BTT), 5)
            XCTAssertEqual(mathData.getGlyphAssemblyPartCount(glyph, .RTL), 0)

            glyph = font.getGlyphWithName("arrowright")
            offset = 0
            repeat {
                count = partsSize
                mathData.getGlyphAssembly(glyph, .RTL, offset, &count, &parts, &itCorr)
                offset += count
            } while count == partsSize
            XCTAssertEqual(offset, 3)
            XCTAssertEqual(parts[0].glyph, font.getGlyphWithName("left"))
            XCTAssertEqual(parts[0].startConnectorLength, pts(400))
            XCTAssertEqual(parts[0].endConnectorLength, pts(192))
            XCTAssertEqual(parts[0].fullAdvance, pts(1000))
            XCTAssert(!parts[0].isExtender())
            XCTAssertEqual(parts[1].glyph, font.getGlyphWithName("horizontal"))
            XCTAssertEqual(parts[1].startConnectorLength, pts(262))
            XCTAssertEqual(parts[1].endConnectorLength, pts(400))
            XCTAssertEqual(parts[1].fullAdvance, pts(1000))
            XCTAssert(parts[1].isExtender())
            XCTAssertEqual(parts[2].glyph, font.getGlyphWithName("right"))
            XCTAssertEqual(parts[2].startConnectorLength, pts(158))
            XCTAssertEqual(parts[2].endConnectorLength, pts(227))
            XCTAssertEqual(parts[2].fullAdvance, pts(1000))
            XCTAssert(!parts[2].isExtender())
            XCTAssertEqual(itCorr, pts(379))
            
            glyph = font.getGlyphWithName("arrowdown")
            offset = 0
            repeat {
                count = partsSize
                mathData.getGlyphAssembly(glyph, .BTT, offset, &count, &parts, &itCorr)
                offset += count
            } while count == partsSize
            XCTAssertEqual(offset, 5)
            XCTAssertEqual(parts[0].glyph, font.getGlyphWithName("bottom"))
            XCTAssertEqual(parts[0].startConnectorLength, pts(365))
            XCTAssertEqual(parts[0].endConnectorLength, pts(158))
            XCTAssertEqual(parts[0].fullAdvance, pts(1000))
            XCTAssert(!parts[0].isExtender())
            XCTAssertEqual(parts[1].glyph, font.getGlyphWithName("vertical"))
            XCTAssertEqual(parts[1].startConnectorLength, pts(227))
            XCTAssertEqual(parts[1].endConnectorLength, pts(365))
            XCTAssertEqual(parts[1].fullAdvance, pts(1000))
            XCTAssert(parts[1].isExtender())
            XCTAssertEqual(parts[2].glyph, font.getGlyphWithName("center"))
            XCTAssertEqual(parts[2].startConnectorLength, pts(54))
            XCTAssertEqual(parts[2].endConnectorLength, pts(158))
            XCTAssertEqual(parts[2].fullAdvance, pts(1000))
            XCTAssert(!parts[2].isExtender())
            XCTAssertEqual(parts[3].glyph, font.getGlyphWithName("vertical"))
            XCTAssertEqual(parts[3].startConnectorLength, pts(400))
            XCTAssertEqual(parts[3].endConnectorLength, pts(296))
            XCTAssertEqual(parts[3].fullAdvance, pts(1000))
            XCTAssert(parts[3].isExtender())
            XCTAssertEqual(parts[4].glyph, font.getGlyphWithName("top"))
            XCTAssertEqual(parts[4].startConnectorLength, pts(123))
            XCTAssertEqual(parts[4].endConnectorLength, pts(192))
            XCTAssertEqual(parts[4].fullAdvance, pts(1000))
            XCTAssert(!parts[4].isExtender())
            XCTAssertEqual(itCorr, pts(237))
        }
    }

    func openCTFont(_ path: String, _ size: CGFloat) -> CTFont {
        let resourcePath = Bundle.module.resourcePath!
        let path = resourcePath + "/" + path

        let fileURL = URL(fileURLWithPath: path)
        let fontDesc = CTFontManagerCreateFontDescriptorsFromURL(fileURL as CFURL) as! [CTFontDescriptor]
        return CTFontCreateWithFontDescriptor(fontDesc[0], size, nil)
    }

    func testDocDemo() {
        do {
            let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
            let mathData = helvetica.createCachedMathData()
            if !mathData.hasData() {
                print("no MATH table")
            }
        }

        do {
            let lmmath = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)
            let mathData = lmmath.createCachedMathData()
            print("axis height, in pts: \(mathData.getConstant(.axisHeight))")
            print("axis height, in pts: \(mathData.axisHeight())")
        }
    }
}
