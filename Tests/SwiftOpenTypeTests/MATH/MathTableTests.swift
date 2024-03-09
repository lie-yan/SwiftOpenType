@testable import SwiftOpenType
import XCTest

final class MathTableTests: XCTestCase {
    func testMathTableHeader() {
        do {
            let helvetica = OTFont(CTFontCreateWithName("Helvetica" as CFString, 12, nil))
            XCTAssert(helvetica.mathTable == nil)
        }

        do {
            let lmmath = openOTFont("fonts/latinmodern-math.otf", 12)
            XCTAssert(lmmath.mathTable != nil)
            let mathTable = lmmath.mathTable!
            XCTAssertEqual(mathTable.majorVersion(), 1)
            XCTAssertEqual(mathTable.minorVersion(), 0)
        }
    }

    func testMathConstants() {
        let font = openOTFont("fonts/latinmodern-math.otf", 12)
        XCTAssertTrue(font.mathTable != nil)

        let ruleThickness: CGFloat = 0.48
        let commonGap: CGFloat = 1.44
        let eps: CGFloat = 1e-15

        XCTAssertEqual(font.scriptPercentScaleDown(), 0.7)
        XCTAssertEqual(font.scriptScriptPercentScaleDown(), 0.5)
        XCTAssertEqual(font.delimitedSubFormulaMinHeight(), 15.6)
        XCTAssertEqual(font.displayOperatorMinHeight(), 15.6)
        XCTAssertEqual(font.mathLeading(), 1.848)
        XCTAssertEqual(font.axisHeight(), 3.0)
        XCTAssertEqual(font.accentBaseHeight(), 5.4)
        XCTAssertEqual(font.flattenedAccentBaseHeight(), 7.968)
        XCTAssertEqual(font.subscriptShiftDown(), 2.964)
        XCTAssertEqual(font.subscriptTopMax(), 4.128)
        XCTAssertEqual(font.subscriptBaselineDropMin(), 2.4)
        XCTAssertEqual(font.superscriptShiftUp(), 4.356)
        XCTAssertEqual(font.superscriptShiftUpCramped(), 3.468)
        XCTAssertEqual(font.superscriptBottomMin(), 1.296)
        XCTAssertEqual(font.superscriptBaselineDropMax(), 3.0)
        XCTAssertEqual(font.subSuperscriptGapMin(), 1.92)
        XCTAssertEqual(font.superscriptBottomMaxWithSubscript(), 4.128)
        XCTAssertEqual(font.spaceAfterScript(), 0.672)
        XCTAssertEqual(font.upperLimitGapMin(), 2.4)
        XCTAssertEqual(font.upperLimitBaselineRiseMin(), 1.332)
        XCTAssertEqual(font.lowerLimitGapMin(), 2.004)
        XCTAssertEqual(font.lowerLimitBaselineDropMin(), 7.2)
        XCTAssertEqual(font.stackTopShiftUp(), 5.328)
        XCTAssertEqual(font.stackTopDisplayStyleShiftUp(), 8.124)
        XCTAssertEqual(font.stackBottomShiftDown(), 4.14)
        XCTAssertEqual(font.stackBottomDisplayStyleShiftDown(), 8.232)
        XCTAssertEqual(font.stackGapMin(), 1.44)
        XCTAssertEqual(font.stackDisplayStyleGapMin(), 3.36)
        XCTAssertEqual(font.stretchStackTopShiftUp(), 1.332)
        XCTAssertEqual(font.stretchStackBottomShiftDown(), 7.2)
        XCTAssertEqual(font.stretchStackGapAboveMin(), 2.4)
        XCTAssertEqual(font.stretchStackGapBelowMin(), 2.004)
        XCTAssertEqual(font.fractionNumeratorShiftUp(), 4.728)
        XCTAssertEqual(font.fractionNumeratorDisplayStyleShiftUp(), 8.124)
        XCTAssertEqual(font.fractionDenominatorShiftDown(), 4.14)
        XCTAssertEqual(font.fractionDenominatorDisplayStyleShiftDown(), 8.232)
        XCTAssertEqual(font.fractionNumeratorGapMin(), ruleThickness)
        XCTAssertEqual(font.fractionNumDisplayStyleGapMin(), commonGap)
        XCTAssertEqual(font.fractionRuleThickness(), ruleThickness)
        XCTAssertEqual(font.fractionDenominatorGapMin(), ruleThickness)
        XCTAssertEqual(font.fractionDenomDisplayStyleGapMin(), commonGap)
        XCTAssertEqual(font.skewedFractionHorizontalGap(), 4.2)
        XCTAssertEqual(font.skewedFractionVerticalGap(), 1.152, accuracy: eps)
        XCTAssertEqual(font.overbarVerticalGap(), commonGap)
        XCTAssertEqual(font.overbarRuleThickness(), ruleThickness)
        XCTAssertEqual(font.overbarExtraAscender(), ruleThickness)
        XCTAssertEqual(font.underbarVerticalGap(), commonGap)
        XCTAssertEqual(font.underbarRuleThickness(), ruleThickness)
        XCTAssertEqual(font.underbarExtraDescender(), ruleThickness)
        XCTAssertEqual(font.radicalVerticalGap(), 0.6)
        XCTAssertEqual(font.radicalDisplayStyleVerticalGap(), 1.776)
        XCTAssertEqual(font.radicalRuleThickness(), ruleThickness)
        XCTAssertEqual(font.radicalExtraAscender(), ruleThickness)
        XCTAssertEqual(font.radicalKernBeforeDegree(), 3.336)
        XCTAssertEqual(font.radicalKernAfterDegree(), -6.672)
        XCTAssertEqual(font.radicalDegreeBottomRaisePercent(), 0.6)
    }

    func testMathConstants_2() {
        var font = openOTFont("fonts/MathTestFontEmpty.otf", 10.0)
        XCTAssert(font.mathTable?.mathConstantsTable == nil) // MathConstants not available

        font = openOTFont("fonts/MathTestFontFull.otf", 10.0)
        let table = font.mathTable!.mathConstantsTable!

        XCTAssertEqual(table.scriptPercentScaleDown(), 87)
        XCTAssertEqual(table.scriptScriptPercentScaleDown(), 76)
        XCTAssertEqual(table.delimitedSubFormulaMinHeight(), 100)
        XCTAssertEqual(table.displayOperatorMinHeight(), 200)
        XCTAssertEqual(table.mathLeading(), 300)
        XCTAssertEqual(table.axisHeight(), 400)
        XCTAssertEqual(table.accentBaseHeight(), 500)
        XCTAssertEqual(table.flattenedAccentBaseHeight(), 600)
        XCTAssertEqual(table.subscriptShiftDown(), 700)
        XCTAssertEqual(table.subscriptTopMax(), 800)
        XCTAssertEqual(table.subscriptBaselineDropMin(), 900)
        XCTAssertEqual(table.superscriptShiftUp(), 1100)
        XCTAssertEqual(table.superscriptShiftUpCramped(), 1200)
        XCTAssertEqual(table.superscriptBottomMin(), 1300)
        XCTAssertEqual(table.superscriptBaselineDropMax(), 1400)
        XCTAssertEqual(table.subSuperscriptGapMin(), 1500)
        XCTAssertEqual(table.superscriptBottomMaxWithSubscript(), 1600)
        XCTAssertEqual(table.spaceAfterScript(), 1700)
        XCTAssertEqual(table.upperLimitGapMin(), 1800)
        XCTAssertEqual(table.upperLimitBaselineRiseMin(), 1900)
        XCTAssertEqual(table.lowerLimitGapMin(), 2200)
        XCTAssertEqual(table.lowerLimitBaselineDropMin(), 2300)
        XCTAssertEqual(table.stackTopShiftUp(), 2400)
        XCTAssertEqual(table.stackTopDisplayStyleShiftUp(), 2500)
        XCTAssertEqual(table.stackBottomShiftDown(), 2600)
        XCTAssertEqual(table.stackBottomDisplayStyleShiftDown(), 2700)
        XCTAssertEqual(table.stackGapMin(), 2800)
        XCTAssertEqual(table.stackDisplayStyleGapMin(), 2900)
        XCTAssertEqual(table.stretchStackTopShiftUp(), 3000)
        XCTAssertEqual(table.stretchStackBottomShiftDown(), 3100)
        XCTAssertEqual(table.stretchStackGapAboveMin(), 3200)
        XCTAssertEqual(table.stretchStackGapBelowMin(), 3300)
        XCTAssertEqual(table.fractionNumeratorShiftUp(), 3400)
        XCTAssertEqual(table.fractionNumeratorDisplayStyleShiftUp(), 3500)
        XCTAssertEqual(table.fractionDenominatorShiftDown(), 3600)
        XCTAssertEqual(table.fractionDenominatorDisplayStyleShiftDown(), 3700)
        XCTAssertEqual(table.fractionNumeratorGapMin(), 3800)
        XCTAssertEqual(table.fractionNumDisplayStyleGapMin(), 3900)
        XCTAssertEqual(table.fractionRuleThickness(), 4000)
        XCTAssertEqual(table.fractionDenominatorGapMin(), 4100)
        XCTAssertEqual(table.fractionDenomDisplayStyleGapMin(), 4200)
        XCTAssertEqual(table.skewedFractionHorizontalGap(), 4300)
        XCTAssertEqual(table.skewedFractionVerticalGap(), 4400)
        XCTAssertEqual(table.overbarVerticalGap(), 4500)
        XCTAssertEqual(table.overbarRuleThickness(), 4600)
        XCTAssertEqual(table.overbarExtraAscender(), 4700)
        XCTAssertEqual(table.underbarVerticalGap(), 4800)
        XCTAssertEqual(table.underbarRuleThickness(), 4900)
        XCTAssertEqual(table.underbarExtraDescender(), 5000)
        XCTAssertEqual(table.radicalVerticalGap(), 5100)
        XCTAssertEqual(table.radicalDisplayStyleVerticalGap(), 5200)
        XCTAssertEqual(table.radicalRuleThickness(), 5300)
        XCTAssertEqual(table.radicalExtraAscender(), 5400)
        XCTAssertEqual(table.radicalKernBeforeDegree(), 5500)
        XCTAssertEqual(table.radicalKernAfterDegree(), 5600)
        XCTAssertEqual(table.radicalDegreeBottomRaisePercent(), 65)
    }

    func testMathItalicsCorrection() {
        let font = openOTFont("fonts/latinmodern-math.otf", 12)
        let glyph = font.getGlyphWithName("f")

        // table
        do {
            let table = font.mathTable!.mathGlyphInfoTable!.mathItalicsCorrectionInfoTable!
            let italicsCorrection = table.getItalicsCorrection(glyph)
            XCTAssertEqual(italicsCorrection, 79)
        }

        // API
        do {
            let pts = font.toPointsClosure()
            XCTAssertEqual(font.getGlyphItalicsCorrection(glyph), pts(79))
        }
    }

    func testMathItalicsCorrection_2() {
        // MathGlyphInfo not available
        do {
            let font = openOTFont("fonts/MathTestFontEmpty.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathItalicsCorrectionInfoTable == nil)
        }

        // MathGlyphInfo empty
        do {
            let font = openOTFont("fonts/MathTestFontPartial1.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathItalicsCorrectionInfoTable == nil)
        }

        // MathItalicsCorrectionInfo empty
        do {
            let font = openOTFont("fonts/MathTestFontPartial2.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathItalicsCorrectionInfoTable != nil)
            let table = font.mathTable!.mathGlyphInfoTable!.mathItalicsCorrectionInfoTable!
            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(table.getItalicsCorrection(glyph), 0)
            XCTAssertEqual(font.getGlyphItalicsCorrection(glyph), 0)
        }

        do {
            let font = openOTFont("fonts/MathTestFontFull.otf", 10)
            let table = font.mathTable!.mathGlyphInfoTable!.mathItalicsCorrectionInfoTable!

            var glyph: CGGlyph
            let pts = font.toPointsClosure()

            glyph = font.getGlyphWithName("space")
            XCTAssertEqual(table.getItalicsCorrection(glyph), 0) // Glyph without italic correction.
            XCTAssertEqual(font.getGlyphItalicsCorrection(glyph), 0)

            glyph = font.getGlyphWithName("A")
            XCTAssertEqual(table.getItalicsCorrection(glyph), 197)
            XCTAssertEqual(font.getGlyphItalicsCorrection(glyph), pts(197))

            glyph = font.getGlyphWithName("B")
            XCTAssertEqual(table.getItalicsCorrection(glyph), 150)
            XCTAssertEqual(font.getGlyphItalicsCorrection(glyph), pts(150))

            glyph = font.getGlyphWithName("C")
            XCTAssertEqual(table.getItalicsCorrection(glyph), 452)
            XCTAssertEqual(font.getGlyphItalicsCorrection(glyph), pts(452))
        }
    }

    func testMathTopAccentAttachment() {
        let font = openOTFont("fonts/latinmodern-math.otf", 12)
        let table = font.mathTable!.mathGlyphInfoTable!.mathTopAccentAttachmentTable!

        var glyph: CGGlyph
        let pts = font.toPointsClosure()

        glyph = font.getGlyphWithName("f")
        XCTAssertEqual(table.getTopAccentAttachment(glyph), 262)
        XCTAssertEqual(font.getGlyphTopAccentAttachment(glyph), pts(262))
    }

    func testMathTopAccentAttachment_2() {
        // MathGlyphInfo not available
        do {
            let font = openOTFont("fonts/MathTestFontEmpty.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathTopAccentAttachmentTable == nil)
        }

        // MathGlyphInfo empty
        do {
            let font = openOTFont("fonts/MathTestFontPartial1.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathTopAccentAttachmentTable == nil)
        }

        // MathTopAccentAttachment empty
        do {
            let font = openOTFont("fonts/MathTestFontPartial2.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathTopAccentAttachmentTable != nil)
            let table = font.mathTable!.mathGlyphInfoTable!.mathTopAccentAttachmentTable!

            let glyph = font.getGlyphWithName("space")
            XCTAssertEqual(table.getTopAccentAttachment(glyph), nil)
        }

        do {
            let font = openOTFont("fonts/MathTestFontFull.otf", 10)
            let table = font.mathTable!.mathGlyphInfoTable!.mathTopAccentAttachmentTable!

            var glyph: CGGlyph
            let pts = font.toPointsClosure()

            glyph = font.getGlyphWithName("space")
            XCTAssertEqual(table.getTopAccentAttachment(glyph), nil)

            let advance = font.getAdvanceForGlyph(.default, glyph)
            let topAccentAttachment = advance / font.sizePerUnit * 0.5
            XCTAssertEqual(topAccentAttachment, 500)
            XCTAssertEqual(font.getGlyphTopAccentAttachment(glyph), pts(500))

            glyph = font.getGlyphWithName("D")
            XCTAssertEqual(table.getTopAccentAttachment(glyph), 374)
            XCTAssertEqual(font.getGlyphTopAccentAttachment(glyph), pts(374))

            glyph = font.getGlyphWithName("E")
            XCTAssertEqual(table.getTopAccentAttachment(glyph), 346)
            XCTAssertEqual(font.getGlyphTopAccentAttachment(glyph), pts(346))

            glyph = font.getGlyphWithName("F")
            XCTAssertEqual(table.getTopAccentAttachment(glyph), 318)
            XCTAssertEqual(font.getGlyphTopAccentAttachment(glyph), pts(318))
        }
    }

    func testMathExtendedShape_2() {
        // MathGlyphInfo not available
        do {
            let font = openOTFont("fonts/MathTestFontEmpty.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.extendedShapeCoverageTable == nil)
        }

        // MathGlyphInfo empty
        do {
            let font = openOTFont("fonts/MathTestFontPartial1.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.extendedShapeCoverageTable == nil)
        }

        do {
            let font = openOTFont("fonts/MathTestFontFull.otf", 10)
            let table = font.mathTable!.mathGlyphInfoTable!.extendedShapeCoverageTable

            var glyph: CGGlyph

            glyph = font.getGlyphWithName("G")
            XCTAssert(table?.getCoverageIndex(glyph) == nil)
            XCTAssertFalse(font.isGlyphExtendedShape(glyph))

            glyph = font.getGlyphWithName("H")
            XCTAssert(table?.getCoverageIndex(glyph) != nil)
            XCTAssertTrue(font.isGlyphExtendedShape(glyph))
        }
    }

    func testMathKernInfo_2() {
        // MathGlyphInfo not available
        do {
            let font = openOTFont("fonts/MathTestFontEmpty.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathKernInfoTable == nil)
        }

        // MathKernInfo empty
        do {
            let font = openOTFont("fonts/MathTestFontPartial2.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathKernInfoTable != nil)
            let table = font.mathTable!.mathGlyphInfoTable!.mathKernInfoTable!
            let glyph = font.getGlyphWithName("space")

            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 0), nil)
            XCTAssertEqual(table.getKernValue(glyph, .TopLeft, 0), nil)
            XCTAssertEqual(table.getKernValue(glyph, .BottomRight, 0), nil)
            XCTAssertEqual(table.getKernValue(glyph, .BottomLeft, 0), nil)

            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(font.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(font.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        // MathKernInfoRecords empty
        do {
            let font = openOTFont("fonts/MathTestFontPartial3.otf", 10)
            XCTAssert(font.mathTable?.mathGlyphInfoTable?.mathKernInfoTable != nil)
            let table = font.mathTable!.mathGlyphInfoTable!.mathKernInfoTable!
            let glyph = font.getGlyphWithName("space")

            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 0), 0)
            XCTAssertEqual(table.getKernValue(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(table.getKernValue(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(table.getKernValue(glyph, .BottomLeft, 0), 0)

            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, 0), 0)
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopLeft, 0), 0)
            XCTAssertEqual(font.getGlyphKerning(glyph, .BottomRight, 0), 0)
            XCTAssertEqual(font.getGlyphKerning(glyph, .BottomLeft, 0), 0)
        }

        do {
            let font = openOTFont("fonts/MathTestFontFull.otf", 10.0)
            let table = font.mathTable!.mathGlyphInfoTable!.mathKernInfoTable!

            let glyph = font.getGlyphWithName("I")
            let pts = font.toPointsClosure()

            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 7), 31) // less than min height
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 14), 52) // equal to min height
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 20), 52)
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 23), 73)
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 31), 73)
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 32), 94)
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 86), 220) // equal to max height
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 91), 220) // larger than max height
            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 96), 220) // larger than max height

            XCTAssertEqual(table.getKernValue(glyph, .TopRight, 39), 94) // top right
            XCTAssertEqual(table.getKernValue(glyph, .TopLeft, 39), 55) // top left
            XCTAssertEqual(table.getKernValue(glyph, .BottomRight, 39), 22) // bottom right
            XCTAssertEqual(table.getKernValue(glyph, .BottomLeft, 39), 50) // bottom left

            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(7)), pts(31)) // less than min height
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(14)), pts(52)) // equal to min height
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(20)), pts(52))
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(23)), pts(73))
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(31)), pts(73))
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(32)), pts(94))
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(86)), pts(220)) // equal to max height
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(91)), pts(220)) // larger than max height
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(96)), pts(220)) // larger than max height

            XCTAssertEqual(font.getGlyphKerning(glyph, .TopRight, pts(39)), pts(94)) // top right
            XCTAssertEqual(font.getGlyphKerning(glyph, .TopLeft, pts(39)), pts(55)) // top left
            XCTAssertEqual(font.getGlyphKerning(glyph, .BottomRight, pts(39)), pts(22)) // bottom right
            XCTAssertEqual(font.getGlyphKerning(glyph, .BottomLeft, pts(39)), pts(50)) // bottom left
        }
    }

    func testGetGlyphKernings() {
        do {
            let font = openOTFont("fonts/MathTestFontFull.otf", 10.0)
            let glyph = font.getGlyphWithName("I")
            let pts = font.toPointsClosure()

            XCTAssertEqual(font.getGlyphKerningCount(glyph, .TopRight, 0), 10)
            XCTAssertEqual(font.getGlyphKerningCount(glyph, .TopLeft, 0), 3)
            XCTAssertEqual(font.getGlyphKerningCount(glyph, .BottomRight, 0), 9)
            XCTAssertEqual(font.getGlyphKerningCount(glyph, .BottomLeft, 0), 7)

            var entries = [MathKernEntry](repeating: .init(), count: 20)

            // case 1
            var count = entries.count
            XCTAssertEqual(font.getGlyphKernings(glyph, .TopRight, 0, &count, &entries), 10)
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
            XCTAssertEqual(font.getGlyphKernings(glyph, .TopLeft, 0, &count, &entries), 3)
            XCTAssertEqual(count, 3)
            XCTAssertEqual(entries[0].maxCorrectionHeight, pts(20))
            XCTAssertEqual(entries[0].kernValue, pts(25))
            XCTAssertEqual(entries[1].maxCorrectionHeight, pts(35))
            XCTAssertEqual(entries[1].kernValue, pts(40))
            XCTAssertEqual(entries[2].maxCorrectionHeight, CGFloat.infinity)
            XCTAssertEqual(entries[2].kernValue, pts(55))
        }
    }

    func openOTFont(_ path: String, _ size: CGFloat) -> OTFont {
        OTFont(openCTFont(path, size))
    }

    func openCTFont(_ path: String, _ size: CGFloat) -> CTFont {
        let resourcePath = Bundle.module.resourcePath!
        let path = resourcePath + "/" + path

        let fileURL = URL(filePath: path)
        let fontDesc = CTFontManagerCreateFontDescriptorsFromURL(fileURL as CFURL) as! [CTFontDescriptor]
        return CTFontCreateWithFontDescriptor(fontDesc[0], size, nil)
    }

    func testExample() {
        let helvetica = OTFont(CTFontCreateWithName("Helvetica" as CFString, 12.0, nil))
        if helvetica.mathTable == nil {
            print("no MATH table")
        }

        let lmmath = OTFont(CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil))
        print("axis height, in pts: \(lmmath.axisHeight())")
    }
}
