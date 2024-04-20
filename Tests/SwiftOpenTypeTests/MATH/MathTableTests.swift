@testable import SwiftOpenType
import XCTest

/// - See also:
///     [test-ot-math.c](https://github.com/harfbuzz/harfbuzz/blob/main/test/api/test-ot-math.c) of
///     [harfbuzz](https://github.com/harfbuzz/harfbuzz)
final class MathTableTests: XCTestCase {
    func testHasData() {
        do {
            let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
            let mathTable = helvetica.createCachedMathTable()
            XCTAssertFalse(mathTable.hasData())
        }

        do {
            let lmmath = openCTFont("fonts/latinmodern-math.otf", 12)
            let mathTable = lmmath.createCachedMathTable()
            XCTAssertTrue(mathTable.hasData())
        }
    }

    func testMathConstants() {
        let lmmath = openCTFont("fonts/latinmodern-math.otf", 12)
        let mathTable = lmmath.createCachedMathTable()
        XCTAssertTrue(mathTable.hasData())

        let ruleThickness: CGFloat = 0.48
        let commonGap: CGFloat = 1.44
        let eps: CGFloat = 1e-15
        let pts = lmmath.toPointsClosure()

        func assertEqual(_ actual: Int32, _ expected: CGFloat) {
            XCTAssertEqual(pts(actual), expected)
        }

        func assertEqual(_ actual: Int32, _ expected: CGFloat, accuracy: CGFloat) {
            XCTAssertEqual(pts(actual), expected, accuracy: accuracy)
        }

        XCTAssertEqual(mathTable.getConstant(.scriptPercentScaleDown), 70)
        XCTAssertEqual(mathTable.getConstant(.scriptScriptPercentScaleDown), 50)
        assertEqual(mathTable.getConstant(.delimitedSubFormulaMinHeight), 15.6)
        assertEqual(mathTable.getConstant(.displayOperatorMinHeight), 15.6)
        assertEqual(mathTable.getConstant(.mathLeading), 1.848)
        assertEqual(mathTable.getConstant(.axisHeight), 3.0)
        assertEqual(mathTable.getConstant(.accentBaseHeight), 5.4)
        assertEqual(mathTable.getConstant(.flattenedAccentBaseHeight), 7.968)
        assertEqual(mathTable.getConstant(.subscriptShiftDown), 2.964)
        assertEqual(mathTable.getConstant(.subscriptTopMax), 4.128)
        assertEqual(mathTable.getConstant(.subscriptBaselineDropMin), 2.4)
        assertEqual(mathTable.getConstant(.superscriptShiftUp), 4.356)
        assertEqual(mathTable.getConstant(.superscriptShiftUpCramped), 3.468)
        assertEqual(mathTable.getConstant(.superscriptBottomMin), 1.296)
        assertEqual(mathTable.getConstant(.superscriptBaselineDropMax), 3.0)
        assertEqual(mathTable.getConstant(.subSuperscriptGapMin), 1.92)
        assertEqual(mathTable.getConstant(.superscriptBottomMaxWithSubscript), 4.128)
        assertEqual(mathTable.getConstant(.spaceAfterScript), 0.672)
        assertEqual(mathTable.getConstant(.upperLimitGapMin), 2.4)
        assertEqual(mathTable.getConstant(.upperLimitBaselineRiseMin), 1.332)
        assertEqual(mathTable.getConstant(.lowerLimitGapMin), 2.004)
        assertEqual(mathTable.getConstant(.lowerLimitBaselineDropMin), 7.2)
        assertEqual(mathTable.getConstant(.stackTopShiftUp), 5.328)
        assertEqual(mathTable.getConstant(.stackTopDisplayStyleShiftUp), 8.124)
        assertEqual(mathTable.getConstant(.stackBottomShiftDown), 4.14)
        assertEqual(mathTable.getConstant(.stackBottomDisplayStyleShiftDown), 8.232)
        assertEqual(mathTable.getConstant(.stackGapMin), 1.44)
        assertEqual(mathTable.getConstant(.stackDisplayStyleGapMin), 3.36)
        assertEqual(mathTable.getConstant(.stretchStackTopShiftUp), 1.332)
        assertEqual(mathTable.getConstant(.stretchStackBottomShiftDown), 7.2)
        assertEqual(mathTable.getConstant(.stretchStackGapAboveMin), 2.4)
        assertEqual(mathTable.getConstant(.stretchStackGapBelowMin), 2.004)
        assertEqual(mathTable.getConstant(.fractionNumeratorShiftUp), 4.728)
        assertEqual(mathTable.getConstant(.fractionNumeratorDisplayStyleShiftUp), 8.124)
        assertEqual(mathTable.getConstant(.fractionDenominatorShiftDown), 4.14)
        assertEqual(mathTable.getConstant(.fractionDenominatorDisplayStyleShiftDown), 8.232)
        assertEqual(mathTable.getConstant(.fractionNumeratorGapMin), ruleThickness)
        assertEqual(mathTable.getConstant(.fractionNumDisplayStyleGapMin), commonGap)
        assertEqual(mathTable.getConstant(.fractionRuleThickness), ruleThickness)
        assertEqual(mathTable.getConstant(.fractionDenominatorGapMin), ruleThickness)
        assertEqual(mathTable.getConstant(.fractionDenomDisplayStyleGapMin), commonGap)
        assertEqual(mathTable.getConstant(.skewedFractionHorizontalGap), 4.2)
        assertEqual(mathTable.getConstant(.skewedFractionVerticalGap), 1.152, accuracy: eps)
        assertEqual(mathTable.getConstant(.overbarVerticalGap), commonGap)
        assertEqual(mathTable.getConstant(.overbarRuleThickness), ruleThickness)
        assertEqual(mathTable.getConstant(.overbarExtraAscender), ruleThickness)
        assertEqual(mathTable.getConstant(.underbarVerticalGap), commonGap)
        assertEqual(mathTable.getConstant(.underbarRuleThickness), ruleThickness)
        assertEqual(mathTable.getConstant(.underbarExtraDescender), ruleThickness)
        assertEqual(mathTable.getConstant(.radicalVerticalGap), 0.6)
        assertEqual(mathTable.getConstant(.radicalDisplayStyleVerticalGap), 1.776)
        assertEqual(mathTable.getConstant(.radicalRuleThickness), ruleThickness)
        assertEqual(mathTable.getConstant(.radicalExtraAscender), ruleThickness)
        assertEqual(mathTable.getConstant(.radicalKernBeforeDegree), 3.336)
        assertEqual(mathTable.getConstant(.radicalKernAfterDegree), -6.672)
        XCTAssertEqual(mathTable.getConstant(.radicalDegreeBottomRaisePercent), 60)
    }

    func testMathConstants_2() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10.0)
            let mathTable = font.createCachedMathTable()
            XCTAssert(mathTable.getConstant(.axisHeight) == 0) // MathConstants not available
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10.0)
            let mathTable = font.createCachedMathTable()

            XCTAssertEqual(mathTable.getConstant(.scriptPercentScaleDown), 87)
            XCTAssertEqual(mathTable.getConstant(.scriptScriptPercentScaleDown), 76)
            XCTAssertEqual(mathTable.getConstant(.delimitedSubFormulaMinHeight), 100)
            XCTAssertEqual(mathTable.getConstant(.displayOperatorMinHeight), 200)
            XCTAssertEqual(mathTable.getConstant(.mathLeading), 300)
            XCTAssertEqual(mathTable.getConstant(.axisHeight), 400)
            XCTAssertEqual(mathTable.getConstant(.accentBaseHeight), 500)
            XCTAssertEqual(mathTable.getConstant(.flattenedAccentBaseHeight), 600)
            XCTAssertEqual(mathTable.getConstant(.subscriptShiftDown), 700)
            XCTAssertEqual(mathTable.getConstant(.subscriptTopMax), 800)
            XCTAssertEqual(mathTable.getConstant(.subscriptBaselineDropMin), 900)
            XCTAssertEqual(mathTable.getConstant(.superscriptShiftUp), 1100)
            XCTAssertEqual(mathTable.getConstant(.superscriptShiftUpCramped), 1200)
            XCTAssertEqual(mathTable.getConstant(.superscriptBottomMin), 1300)
            XCTAssertEqual(mathTable.getConstant(.superscriptBaselineDropMax), 1400)
            XCTAssertEqual(mathTable.getConstant(.subSuperscriptGapMin), 1500)
            XCTAssertEqual(mathTable.getConstant(.superscriptBottomMaxWithSubscript), 1600)
            XCTAssertEqual(mathTable.getConstant(.spaceAfterScript), 1700)
            XCTAssertEqual(mathTable.getConstant(.upperLimitGapMin), 1800)
            XCTAssertEqual(mathTable.getConstant(.upperLimitBaselineRiseMin), 1900)
            XCTAssertEqual(mathTable.getConstant(.lowerLimitGapMin), 2200)
            XCTAssertEqual(mathTable.getConstant(.lowerLimitBaselineDropMin), 2300)
            XCTAssertEqual(mathTable.getConstant(.stackTopShiftUp), 2400)
            XCTAssertEqual(mathTable.getConstant(.stackTopDisplayStyleShiftUp), 2500)
            XCTAssertEqual(mathTable.getConstant(.stackBottomShiftDown), 2600)
            XCTAssertEqual(mathTable.getConstant(.stackBottomDisplayStyleShiftDown), 2700)
            XCTAssertEqual(mathTable.getConstant(.stackGapMin), 2800)
            XCTAssertEqual(mathTable.getConstant(.stackDisplayStyleGapMin), 2900)
            XCTAssertEqual(mathTable.getConstant(.stretchStackTopShiftUp), 3000)
            XCTAssertEqual(mathTable.getConstant(.stretchStackBottomShiftDown), 3100)
            XCTAssertEqual(mathTable.getConstant(.stretchStackGapAboveMin), 3200)
            XCTAssertEqual(mathTable.getConstant(.stretchStackGapBelowMin), 3300)
            XCTAssertEqual(mathTable.getConstant(.fractionNumeratorShiftUp), 3400)
            XCTAssertEqual(mathTable.getConstant(.fractionNumeratorDisplayStyleShiftUp), 3500)
            XCTAssertEqual(mathTable.getConstant(.fractionDenominatorShiftDown), 3600)
            XCTAssertEqual(mathTable.getConstant(.fractionDenominatorDisplayStyleShiftDown), 3700)
            XCTAssertEqual(mathTable.getConstant(.fractionNumeratorGapMin), 3800)
            XCTAssertEqual(mathTable.getConstant(.fractionNumDisplayStyleGapMin), 3900)
            XCTAssertEqual(mathTable.getConstant(.fractionRuleThickness), 4000)
            XCTAssertEqual(mathTable.getConstant(.fractionDenominatorGapMin), 4100)
            XCTAssertEqual(mathTable.getConstant(.fractionDenomDisplayStyleGapMin), 4200)
            XCTAssertEqual(mathTable.getConstant(.skewedFractionHorizontalGap), 4300)
            XCTAssertEqual(mathTable.getConstant(.skewedFractionVerticalGap), 4400)
            XCTAssertEqual(mathTable.getConstant(.overbarVerticalGap), 4500)
            XCTAssertEqual(mathTable.getConstant(.overbarRuleThickness), 4600)
            XCTAssertEqual(mathTable.getConstant(.overbarExtraAscender), 4700)
            XCTAssertEqual(mathTable.getConstant(.underbarVerticalGap), 4800)
            XCTAssertEqual(mathTable.getConstant(.underbarRuleThickness), 4900)
            XCTAssertEqual(mathTable.getConstant(.underbarExtraDescender), 5000)
            XCTAssertEqual(mathTable.getConstant(.radicalVerticalGap), 5100)
            XCTAssertEqual(mathTable.getConstant(.radicalDisplayStyleVerticalGap), 5200)
            XCTAssertEqual(mathTable.getConstant(.radicalRuleThickness), 5300)
            XCTAssertEqual(mathTable.getConstant(.radicalExtraAscender), 5400)
            XCTAssertEqual(mathTable.getConstant(.radicalKernBeforeDegree), 5500)
            XCTAssertEqual(mathTable.getConstant(.radicalKernAfterDegree), 5600)
            XCTAssertEqual(mathTable.getConstant(.radicalDegreeBottomRaisePercent), 65)
        }
    }

    func testMathItalicsCorrection() {
        let font = openCTFont("fonts/latinmodern-math.otf", 12)

        let glyph = font.getGlyphWithName("f")

        let mathTable = font.createCachedMathTable()
        XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 79)
    }

    func testMathItalicsCorrection_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathTable = font.createCachedMathTable()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 0)
        }

        // MathGlyphInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathTable = font.createCachedMathTable()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 0)
        }

        // MathItalicsCorrectionInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let mathTable = font.createCachedMathTable()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)

            let mathTable = font.createCachedMathTable()

            var glyph: CGGlyph

            glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 0) // Glyph without italic correction.

            glyph = font.getGlyphWithName("A")
            XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 197)

            glyph = font.getGlyphWithName("B")
            XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 150)

            glyph = font.getGlyphWithName("C")
            XCTAssertEqual(mathTable.getGlyphItalicsCorrection(glyph), 452)
        }
    }

    func testMathTopAccentAttachment() {
        let font = openCTFont("fonts/latinmodern-math.otf", 12)

        let mathTable = font.createCachedMathTable()

        let glyph = font.getGlyphWithName("f")
        XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 262)
    }

    func testMathTopAccentAttachment_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)

            let mathTable = font.createCachedMathTable()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 500)
        }

        // MathGlyphInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)

            let mathTable = font.createCachedMathTable()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 500)
        }

        // MathTopAccentAttachment empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)

            let mathTable = font.createCachedMathTable()
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 500)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)

            let mathTable = font.createCachedMathTable()

            var glyph: CGGlyph

            glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 500)

            glyph = font.getGlyphWithName("D")
            XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 374)

            glyph = font.getGlyphWithName("E")
            XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 346)

            glyph = font.getGlyphWithName("F")
            XCTAssertEqual(mathTable.getGlyphTopAccentAttachment(glyph), 318)
        }
    }

    func testMathExtendedShape_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathTable = font.createCachedMathTable()
            XCTAssertFalse(mathTable.isGlyphExtendedShape(glyph))
        }

        // MathGlyphInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathTable = font.createCachedMathTable()
            XCTAssertFalse(mathTable.isGlyphExtendedShape(glyph))
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathTable = font.createCachedMathTable()

            var glyph: CGGlyph

            glyph = font.getGlyphWithName("G")
            XCTAssertFalse(mathTable.isGlyphExtendedShape(glyph))

            glyph = font.getGlyphWithName("H")
            XCTAssert(mathTable.isGlyphExtendedShape(glyph))
        }
    }

    func testMathKernInfo_2() {
        // MathGlyphInfo not available
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathTable = font.createCachedMathTable()
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        // MathKernInfo empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathTable = font.createCachedMathTable()
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        // MathKernInfoRecords empty
        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let glyph = font.getGlyphWithName("space")
            let mathTable = font.createCachedMathTable()
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("I")

            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 7), 31) // less than min height
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 14), 52) // equal to min height
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 20), 52)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 23), 73)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 31), 73)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 32), 94)
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 86), 220) // equal to max height
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 91), 220) // larger than max height
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 96), 220) // larger than max height

            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopRight, 39), 94) // top right
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .TopLeft, 39), 55) // top left
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomRight, 39), 22) // bottom right
            XCTAssertEqual(mathTable.getGlyphKerning(glyph, .BottomLeft, 39), 50) // bottom left
        }
    }

    func testGetGlyphKernings() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let glyph = font.getGlyphWithName("space")

            let mathTable = font.createCachedMathTable()
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopRight), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopLeft), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomRight), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomLeft), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let glyph = font.getGlyphWithName("space")

            let mathTable = font.createCachedMathTable()
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopRight), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopLeft), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomRight), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomLeft), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let glyph = font.getGlyphWithName("space")

            let mathTable = font.createCachedMathTable()
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopRight), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopLeft), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomRight), 0)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomLeft), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10.0)
            let glyph = font.getGlyphWithName("I")

            let mathTable = font.createCachedMathTable()

            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopRight, 0), 10)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .TopLeft, 0), 3)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomRight, 0), 9)
            XCTAssertEqual(mathTable.getGlyphKerningCount(glyph, .BottomLeft, 0), 7)

            let entriesCount = 20
            var entries = [MathKernEntry](repeating: .init(), count: entriesCount)

            // case 1
            var count = entries.count
            XCTAssertEqual(mathTable.getGlyphKernings(glyph, .TopRight, 0, &count, &entries), 10)
            XCTAssertEqual(count, 10)
            XCTAssertEqual(entries[0].maxCorrectionHeight, 14)
            XCTAssertEqual(entries[0].kernValue, 31)
            XCTAssertEqual(entries[1].maxCorrectionHeight, 23)
            XCTAssertEqual(entries[1].kernValue, 52)
            XCTAssertEqual(entries[2].maxCorrectionHeight, 32)
            XCTAssertEqual(entries[2].kernValue, 73)
            XCTAssertEqual(entries[3].maxCorrectionHeight, 41)
            XCTAssertEqual(entries[3].kernValue, 94)
            XCTAssertEqual(entries[4].maxCorrectionHeight, 50)
            XCTAssertEqual(entries[4].kernValue, 115)
            XCTAssertEqual(entries[5].maxCorrectionHeight, 59)
            XCTAssertEqual(entries[5].kernValue, 136)
            XCTAssertEqual(entries[6].maxCorrectionHeight, 68)
            XCTAssertEqual(entries[6].kernValue, 157)
            XCTAssertEqual(entries[7].maxCorrectionHeight, 77)
            XCTAssertEqual(entries[7].kernValue, 178)
            XCTAssertEqual(entries[8].maxCorrectionHeight, 86)
            XCTAssertEqual(entries[8].kernValue, 199)
            XCTAssertEqual(entries[9].maxCorrectionHeight, Int32.max)
            XCTAssertEqual(entries[9].kernValue, 220)

            // case 2
            count = entries.count
            XCTAssertEqual(mathTable.getGlyphKernings(glyph, .TopLeft, 0, &count, &entries), 3)
            XCTAssertEqual(count, 3)
            XCTAssertEqual(entries[0].maxCorrectionHeight, 20)
            XCTAssertEqual(entries[0].kernValue, 25)
            XCTAssertEqual(entries[1].maxCorrectionHeight, 35)
            XCTAssertEqual(entries[1].kernValue, 40)
            XCTAssertEqual(entries[2].maxCorrectionHeight, Int32.max)
            XCTAssertEqual(entries[2].kernValue, 55)
        }
    }

    func testGetGlyphVariants() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial4.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .BTT), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathTable = font.createCachedMathTable()

            let variantsSize = 20
            var variants = [MathGlyphVariant](repeating: .init(), count: variantsSize)
            var count = 0
            var offset = 0

            var glyph = font.getGlyphWithName("arrowleft")
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .BTT), 0)
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .RTL), 3)

            glyph = font.getGlyphWithName("arrowup")
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .BTT), 4)
            XCTAssertEqual(mathTable.getGlyphVariantCount(glyph, .RTL), 0)

            glyph = font.getGlyphWithName("arrowleft")
            offset = 0
            repeat {
                count = variantsSize
                mathTable.getGlyphVariants(glyph, .RTL, offset, &count, &variants)
                offset += count
            } while count == variantsSize
            XCTAssertEqual(offset, 3)
            XCTAssertEqual(variants[0].glyph, font.getGlyphWithName("uni2190_size2"))
            XCTAssertEqual(variants[0].advance, 2151)
            XCTAssertEqual(variants[1].glyph, font.getGlyphWithName("uni2190_size3"))
            XCTAssertEqual(variants[1].advance, 2401)
            XCTAssertEqual(variants[2].glyph, font.getGlyphWithName("uni2190_size4"))
            XCTAssertEqual(variants[2].advance, 2901)

            glyph = font.getGlyphWithName("arrowup")
            offset = 0
            repeat {
                count = variantsSize
                mathTable.getGlyphVariants(glyph, .BTT, offset, &count, &variants)
                offset += count
            } while count == variantsSize
            XCTAssertEqual(offset, 4)
            XCTAssertEqual(variants[0].glyph, font.getGlyphWithName("uni2191_size2"))
            XCTAssertEqual(variants[0].advance, 2251)
            XCTAssertEqual(variants[1].glyph, font.getGlyphWithName("uni2191_size3"))
            XCTAssertEqual(variants[1].advance, 2501)
            XCTAssertEqual(variants[2].glyph, font.getGlyphWithName("uni2191_size4"))
            XCTAssertEqual(variants[2].advance, 3001)
            XCTAssertEqual(variants[3].glyph, font.getGlyphWithName("uni2191_size5"))
            XCTAssertEqual(variants[3].advance, 3751)
        }
    }

    func testGetMinConnectorOverlap() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathTable = font.createCachedMathTable()

            XCTAssertEqual(mathTable.getMinConnectorOverlap(.LTR), 0)
            XCTAssertEqual(mathTable.getMinConnectorOverlap(.TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathTable = font.createCachedMathTable()

            XCTAssertEqual(mathTable.getMinConnectorOverlap(.LTR), 54)
            XCTAssertEqual(mathTable.getMinConnectorOverlap(.TTB), 54)
        }
    }

    func testGetGlyphAssembly() {
        do {
            let font = openCTFont("fonts/MathTestFontEmpty.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial1.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial2.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial3.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontPartial4.otf", 10)
            let mathTable = font.createCachedMathTable()

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .RTL), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .BTT), 0)

            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)
        }

        do {
            let font = openCTFont("fonts/MathTestFontFull.otf", 10)
            let mathTable = font.createCachedMathTable()

            let partsSize = 20
            var parts = [GlyphPart](repeating: .init(), count: partsSize)
            var count = 0
            var itCorr: Int32 = 0
            var offset = 0

            var glyph = font.getGlyphWithName("arrowleft")
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 124)
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 0)

            glyph = font.getGlyphWithName("arrowup")
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .LTR), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyItalicsCorrection(glyph, .TTB), 331)

            glyph = font.getGlyphWithName("arrowright")
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .BTT), 0)
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .RTL), 3)

            glyph = font.getGlyphWithName("arrowdown")
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .BTT), 5)
            XCTAssertEqual(mathTable.getGlyphAssemblyPartCount(glyph, .RTL), 0)

            glyph = font.getGlyphWithName("arrowright")
            offset = 0
            repeat {
                count = partsSize
                mathTable.getGlyphAssembly(glyph, .RTL, offset, &count, &parts, &itCorr)
                offset += count
            } while count == partsSize
            XCTAssertEqual(offset, 3)
            XCTAssertEqual(parts[0].glyph, font.getGlyphWithName("left"))
            XCTAssertEqual(parts[0].startConnectorLength, 400)
            XCTAssertEqual(parts[0].endConnectorLength, 192)
            XCTAssertEqual(parts[0].fullAdvance, 1000)
            XCTAssert(!parts[0].isExtender())
            XCTAssertEqual(parts[1].glyph, font.getGlyphWithName("horizontal"))
            XCTAssertEqual(parts[1].startConnectorLength, 262)
            XCTAssertEqual(parts[1].endConnectorLength, 400)
            XCTAssertEqual(parts[1].fullAdvance, 1000)
            XCTAssert(parts[1].isExtender())
            XCTAssertEqual(parts[2].glyph, font.getGlyphWithName("right"))
            XCTAssertEqual(parts[2].startConnectorLength, 158)
            XCTAssertEqual(parts[2].endConnectorLength, 227)
            XCTAssertEqual(parts[2].fullAdvance, 1000)
            XCTAssert(!parts[2].isExtender())
            XCTAssertEqual(itCorr, 379)

            glyph = font.getGlyphWithName("arrowdown")
            offset = 0
            repeat {
                count = partsSize
                mathTable.getGlyphAssembly(glyph, .BTT, offset, &count, &parts, &itCorr)
                offset += count
            } while count == partsSize
            XCTAssertEqual(offset, 5)
            XCTAssertEqual(parts[0].glyph, font.getGlyphWithName("bottom"))
            XCTAssertEqual(parts[0].startConnectorLength, 365)
            XCTAssertEqual(parts[0].endConnectorLength, 158)
            XCTAssertEqual(parts[0].fullAdvance, 1000)
            XCTAssert(!parts[0].isExtender())
            XCTAssertEqual(parts[1].glyph, font.getGlyphWithName("vertical"))
            XCTAssertEqual(parts[1].startConnectorLength, 227)
            XCTAssertEqual(parts[1].endConnectorLength, 365)
            XCTAssertEqual(parts[1].fullAdvance, 1000)
            XCTAssert(parts[1].isExtender())
            XCTAssertEqual(parts[2].glyph, font.getGlyphWithName("center"))
            XCTAssertEqual(parts[2].startConnectorLength, 54)
            XCTAssertEqual(parts[2].endConnectorLength, 158)
            XCTAssertEqual(parts[2].fullAdvance, 1000)
            XCTAssert(!parts[2].isExtender())
            XCTAssertEqual(parts[3].glyph, font.getGlyphWithName("vertical"))
            XCTAssertEqual(parts[3].startConnectorLength, 400)
            XCTAssertEqual(parts[3].endConnectorLength, 296)
            XCTAssertEqual(parts[3].fullAdvance, 1000)
            XCTAssert(parts[3].isExtender())
            XCTAssertEqual(parts[4].glyph, font.getGlyphWithName("top"))
            XCTAssertEqual(parts[4].startConnectorLength, 123)
            XCTAssertEqual(parts[4].endConnectorLength, 192)
            XCTAssertEqual(parts[4].fullAdvance, 1000)
            XCTAssert(!parts[4].isExtender())
            XCTAssertEqual(itCorr, 237)
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
            let mathTable = helvetica.createCachedMathTable()
            if !mathTable.hasData() {
                print("no MATH table")
            }
        }

        do {
            let lmmath = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)
            let mathTable = lmmath.createCachedMathTable()
            print("axis height, in design units: \(mathTable.getConstant(.axisHeight))")
        }
    }
}
