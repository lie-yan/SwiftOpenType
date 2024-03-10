import CoreFoundation
import CoreText

public class MathData {
    let font: CTFont
    let ppem: UInt32
    let sizePerUnit: CGFloat

    init(_ font: CTFont, ppem: UInt32 = 0) {
        self.font = font
        self.ppem = ppem
        sizePerUnit = font.getSize() / CGFloat(font.getUnitsPerEm())
    }

    private lazy var mathTable: MathTable? = font.getMathTable(ppem: ppem)

    private lazy var mathConstantsTable: MathConstantsTable? = self.mathTable?.mathConstantsTable

    private lazy var mathGlyphInfoTable: MathGlyphInfoTable? = self.mathTable?.mathGlyphInfoTable

    private lazy var mathVariantsTable: MathVariantsTable? = self.mathTable?.mathVariantsTable

    private func toPoints<T: BinaryInteger>(_ designUnits: T) -> CGFloat {
        CGFloat(designUnits) * sizePerUnit
    }

    private func toDesignUnits(_ points: CGFloat) -> Int32 {
        Int32(points / sizePerUnit)
    }

    private func toRatio(_ percentage: Int32) -> CGFloat {
        CGFloat(percentage) / 100
    }

    // MARK: -

    public func hasData() -> Bool {
        mathTable != nil
    }

    // MARK: - MathConstants

    /// Returns the requested constant or zero
    public func getConstant(_ index: MathConstant) -> CGFloat {
        if let table = mathConstantsTable {
            if index <= MathConstant.scriptScriptPercentScaleDown {
                return toRatio(table.getPercent(index))
            } else if index <= MathConstant.displayOperatorMinHeight {
                return toPoints(table.getMinHeight(index))
            } else if index <= MathConstant.radicalKernAfterDegree {
                return toPoints(table.getMathValue(index))
            } else if index == MathConstant.radicalDegreeBottomRaisePercent {
                return toRatio(table.getPercent(index))
            }
            fatalError("Unreachable")
        } else {
            return 0
        }
    }

    public func scriptPercentScaleDown() -> CGFloat {
        toRatio(mathConstantsTable?.scriptPercentScaleDown() ?? 0)
    }

    public func scriptScriptPercentScaleDown() -> CGFloat {
        toRatio(mathConstantsTable?.scriptScriptPercentScaleDown() ?? 0)
    }

    public func delimitedSubFormulaMinHeight() -> CGFloat {
        toPoints(mathConstantsTable?.delimitedSubFormulaMinHeight() ?? 0)
    }

    public func displayOperatorMinHeight() -> CGFloat {
        toPoints(mathConstantsTable?.displayOperatorMinHeight() ?? 0)
    }

    public func mathLeading() -> CGFloat {
        toPoints(mathConstantsTable?.mathLeading() ?? 0)
    }

    public func axisHeight() -> CGFloat {
        toPoints(mathConstantsTable?.axisHeight() ?? 0)
    }

    public func accentBaseHeight() -> CGFloat {
        toPoints(mathConstantsTable?.accentBaseHeight() ?? 0)
    }

    public func flattenedAccentBaseHeight() -> CGFloat {
        toPoints(mathConstantsTable?.flattenedAccentBaseHeight() ?? 0)
    }

    public func subscriptShiftDown() -> CGFloat {
        toPoints(mathConstantsTable?.subscriptShiftDown() ?? 0)
    }

    public func subscriptTopMax() -> CGFloat {
        toPoints(mathConstantsTable?.subscriptTopMax() ?? 0)
    }

    public func subscriptBaselineDropMin() -> CGFloat {
        toPoints(mathConstantsTable?.subscriptBaselineDropMin() ?? 0)
    }

    public func superscriptShiftUp() -> CGFloat {
        toPoints(mathConstantsTable?.superscriptShiftUp() ?? 0)
    }

    public func superscriptShiftUpCramped() -> CGFloat {
        toPoints(mathConstantsTable?.superscriptShiftUpCramped() ?? 0)
    }

    public func superscriptBottomMin() -> CGFloat {
        toPoints(mathConstantsTable?.superscriptBottomMin() ?? 0)
    }

    public func superscriptBaselineDropMax() -> CGFloat {
        toPoints(mathConstantsTable?.superscriptBaselineDropMax() ?? 0)
    }

    public func subSuperscriptGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.subSuperscriptGapMin() ?? 0)
    }

    public func superscriptBottomMaxWithSubscript() -> CGFloat {
        toPoints(mathConstantsTable?.superscriptBottomMaxWithSubscript() ?? 0)
    }

    public func spaceAfterScript() -> CGFloat {
        toPoints(mathConstantsTable?.spaceAfterScript() ?? 0)
    }

    public func upperLimitGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.upperLimitGapMin() ?? 0)
    }

    public func upperLimitBaselineRiseMin() -> CGFloat {
        toPoints(mathConstantsTable?.upperLimitBaselineRiseMin() ?? 0)
    }

    public func lowerLimitGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.lowerLimitGapMin() ?? 0)
    }

    public func lowerLimitBaselineDropMin() -> CGFloat {
        toPoints(mathConstantsTable?.lowerLimitBaselineDropMin() ?? 0)
    }

    public func stackTopShiftUp() -> CGFloat {
        toPoints(mathConstantsTable?.stackTopShiftUp() ?? 0)
    }

    public func stackTopDisplayStyleShiftUp() -> CGFloat {
        toPoints(mathConstantsTable?.stackTopDisplayStyleShiftUp() ?? 0)
    }

    public func stackBottomShiftDown() -> CGFloat {
        toPoints(mathConstantsTable?.stackBottomShiftDown() ?? 0)
    }

    public func stackBottomDisplayStyleShiftDown() -> CGFloat {
        toPoints(mathConstantsTable?.stackBottomDisplayStyleShiftDown() ?? 0)
    }

    public func stackGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.stackGapMin() ?? 0)
    }

    public func stackDisplayStyleGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.stackDisplayStyleGapMin() ?? 0)
    }

    public func stretchStackTopShiftUp() -> CGFloat {
        toPoints(mathConstantsTable?.stretchStackTopShiftUp() ?? 0)
    }

    public func stretchStackBottomShiftDown() -> CGFloat {
        toPoints(mathConstantsTable?.stretchStackBottomShiftDown() ?? 0)
    }

    public func stretchStackGapAboveMin() -> CGFloat {
        toPoints(mathConstantsTable?.stretchStackGapAboveMin() ?? 0)
    }

    public func stretchStackGapBelowMin() -> CGFloat {
        toPoints(mathConstantsTable?.stretchStackGapBelowMin() ?? 0)
    }

    public func fractionNumeratorShiftUp() -> CGFloat {
        toPoints(mathConstantsTable?.fractionNumeratorShiftUp() ?? 0)
    }

    public func fractionNumeratorDisplayStyleShiftUp() -> CGFloat {
        toPoints(mathConstantsTable?.fractionNumeratorDisplayStyleShiftUp() ?? 0)
    }

    public func fractionDenominatorShiftDown() -> CGFloat {
        toPoints(mathConstantsTable?.fractionDenominatorShiftDown() ?? 0)
    }

    public func fractionDenominatorDisplayStyleShiftDown() -> CGFloat {
        toPoints(mathConstantsTable?.fractionDenominatorDisplayStyleShiftDown() ?? 0)
    }

    public func fractionNumeratorGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.fractionNumeratorGapMin() ?? 0)
    }

    public func fractionNumDisplayStyleGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.fractionNumDisplayStyleGapMin() ?? 0)
    }

    public func fractionRuleThickness() -> CGFloat {
        toPoints(mathConstantsTable?.fractionRuleThickness() ?? 0)
    }

    public func fractionDenominatorGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.fractionDenominatorGapMin() ?? 0)
    }

    public func fractionDenomDisplayStyleGapMin() -> CGFloat {
        toPoints(mathConstantsTable?.fractionDenomDisplayStyleGapMin() ?? 0)
    }

    public func skewedFractionHorizontalGap() -> CGFloat {
        toPoints(mathConstantsTable?.skewedFractionHorizontalGap() ?? 0)
    }

    public func skewedFractionVerticalGap() -> CGFloat {
        toPoints(mathConstantsTable?.skewedFractionVerticalGap() ?? 0)
    }

    public func overbarVerticalGap() -> CGFloat {
        toPoints(mathConstantsTable?.overbarVerticalGap() ?? 0)
    }

    public func overbarRuleThickness() -> CGFloat {
        toPoints(mathConstantsTable?.overbarRuleThickness() ?? 0)
    }

    public func overbarExtraAscender() -> CGFloat {
        toPoints(mathConstantsTable?.overbarExtraAscender() ?? 0)
    }

    public func underbarVerticalGap() -> CGFloat {
        toPoints(mathConstantsTable?.underbarVerticalGap() ?? 0)
    }

    public func underbarRuleThickness() -> CGFloat {
        toPoints(mathConstantsTable?.underbarRuleThickness() ?? 0)
    }

    public func underbarExtraDescender() -> CGFloat {
        toPoints(mathConstantsTable?.underbarExtraDescender() ?? 0)
    }

    public func radicalVerticalGap() -> CGFloat {
        toPoints(mathConstantsTable?.radicalVerticalGap() ?? 0)
    }

    public func radicalDisplayStyleVerticalGap() -> CGFloat {
        toPoints(mathConstantsTable?.radicalDisplayStyleVerticalGap() ?? 0)
    }

    public func radicalRuleThickness() -> CGFloat {
        toPoints(mathConstantsTable?.radicalRuleThickness() ?? 0)
    }

    public func radicalExtraAscender() -> CGFloat {
        toPoints(mathConstantsTable?.radicalExtraAscender() ?? 0)
    }

    public func radicalKernBeforeDegree() -> CGFloat {
        toPoints(mathConstantsTable?.radicalKernBeforeDegree() ?? 0)
    }

    public func radicalKernAfterDegree() -> CGFloat {
        toPoints(mathConstantsTable?.radicalKernAfterDegree() ?? 0)
    }

    public func radicalDegreeBottomRaisePercent() -> CGFloat {
        toRatio(mathConstantsTable?.radicalDegreeBottomRaisePercent() ?? 0)
    }

    // MARK: - MathGlyphInfo

    /// Returns the italics correction of the glyph or zero
    public func getGlyphItalicsCorrection(_ glyph: UInt16) -> CGFloat {
        let value = mathGlyphInfoTable?.mathItalicsCorrectionInfoTable?.getItalicsCorrection(glyph)
        return toPoints(value ?? 0)
    }

    /// Returns the top accent attachment of the glyph or 0.5 * the advance width of glyph
    public func getGlyphTopAccentAttachment(_ glyph: UInt16) -> CGFloat {
        if let value = mathGlyphInfoTable?.mathTopAccentAttachmentTable?.getTopAccentAttachment(glyph) {
            return toPoints(value)
        } else {
            return 0.5 * font.getAdvanceForGlyph(.horizontal, glyph)
        }
    }

    /// Returns requested kerning value or zero
    public func getGlyphKerning(_ glyph: UInt16,
                                _ corner: MathKernCorner,
                                _ correctionHeight: CGFloat) -> CGFloat
    {
        let value = mathGlyphInfoTable?.mathKernInfoTable?.getKernValue(glyph, corner, toDesignUnits(correctionHeight))
        return toPoints(value ?? 0)
    }

    /// Fetches the raw MathKern (cut-in) data for glyph index, and corner.
    ///
    /// - Parameters:
    ///   - glyph: The glyph index from which to retrieve the kernings
    ///   - corner: The corner for which to retrieve the kernings
    ///   - startOffset: offset of the first kern entry to retrieve
    ///   - entriesCount: Input = the maximum number of kern entries to return;
    ///     Output = the actual number of kern entries returned.
    ///   - kernEntries: array of kern entries returned.
    ///
    /// - Returns: the total number of kern values available or zero
    public func getGlyphKernings(_ glyph: UInt16,
                                 _ corner: MathKernCorner,
                                 _ startOffset: Int,
                                 _ entriesCount: inout Int,
                                 _ kernEntries: inout [MathKernEntry]) -> Int
    {
        precondition(startOffset >= 0)
        precondition(entriesCount >= 0)
        precondition(kernEntries.count >= entriesCount)

        if let kernTable = mathGlyphInfoTable?.mathKernInfoTable?
            .getMathKernTable(glyph, corner)
        {
            let heightCount = Int(kernTable.heightCount())
            let count = heightCount + 1
            let start = min(startOffset, count)
            let end = min(start + entriesCount, count)
            entriesCount = end - start

            for i in 0 ..< entriesCount {
                let j = start + i

                var maxHeight: CGFloat
                if j == heightCount {
                    maxHeight = CGFloat.infinity
                } else {
                    maxHeight = toPoints(kernTable.getCorrectionHeight(j))
                }

                let kernValue = toPoints(kernTable.getKernValue(index: j))
                kernEntries[i] = MathKernEntry(maxCorrectionHeight: maxHeight, kernValue: kernValue)
            }
            return entriesCount
        }

        // FALL THRU
        entriesCount = 0
        return 0
    }

    /// Returns the count of kern entries available for glyph index and corner, counting from given offset.
    ///
    /// - Parameters:
    ///   - glyph: The glyph index from which to retrieve the kernings
    ///   - corner: The corner for which to retrieve the kernings
    ///   - startOffset: offset of the first kern entry to retrieve
    ///
    /// - Returns: the total number of kern values available or zero
    public func getGlyphKerningCount(_ glyph: UInt16,
                                     _ corner: MathKernCorner,
                                     _ startOffset: Int = 0) -> Int
    {
        precondition(startOffset >= 0)
        return mathGlyphInfoTable?.mathKernInfoTable?
            .getMathKernTable(glyph, corner)?
            .getKernEntryCount(startOffset: startOffset) ?? 0
    }

    /// Returns true if the glyph is an extended shape, false otherwise
    public func isGlyphExtendedShape(_ glyph: UInt16) -> Bool {
        mathGlyphInfoTable?.extendedShapeCoverageTable?.getCoverageIndex(glyph) != nil
    }

    // MARK: - MathVariants

    /// Returns requested minimum connector overlap or zero
    public func getMinConnectorOverlap(_: TextDirection) -> CGFloat {
        let value = mathVariantsTable?.minConnectorOverlap()
        return toPoints(value ?? 0)
    }

    @discardableResult
    public func getGlyphVariants(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int,
        _ variantsCount: inout Int,
        _ variants: inout [MathGlyphVariant]
    ) -> Int {
        precondition(startOffset >= 0)
        precondition(variantsCount >= 0)
        precondition(variants.count >= variantsCount)

        if let table = getMathGlyphConstructionTable(glyph, direction) {
            let count = Int(table.variantCount())
            let start = min(startOffset, count)
            let end = min(startOffset + variantsCount, count)
            variantsCount = end - start

            for i in 0 ..< variantsCount {
                let j = start + i
                let record = table.mathGlyphVariantRecord(j)

                variants[i] = MathGlyphVariant(glyph: record.variantGlyph,
                                               advance: toPoints(record.advanceMeasurement))
            }
            return variantsCount
        }

        // FALL THRU
        variantsCount = 0
        return 0
    }

    public func getGlyphVariantCount(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int = 0
    ) -> Int {
        precondition(startOffset >= 0)

        if let table = getMathGlyphConstructionTable(glyph, direction) {
            let count = Int(table.variantCount())
            return count - min(startOffset, count)
        }

        // FALL THRU
        return 0
    }

    @discardableResult
    public func getGlyphAssembly(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int,
        _ partsCount: inout Int,
        _ parts: inout [GlyphPart],
        _ italicsCorrection: inout CGFloat
    ) -> Int {
        if let table = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable {
            getGlyphAssemblyParts(table, startOffset, &partsCount, &parts)
            italicsCorrection = toPoints(table.getItalicsCorrection())
            return partsCount
        }

        // FALL THRU
        partsCount = 0
        italicsCorrection = 0
        return 0
    }

    public func getGlyphAssemblyItalicsCorrection(
        _ glyph: UInt16,
        _ direction: TextDirection
    ) -> CGFloat {
        let value = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable?.getItalicsCorrection()
        return toPoints(value ?? 0)
    }

    public func getGlyphAssemblyParts(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int,
        _ partsCount: inout Int,
        _ parts: inout [GlyphPart]
    ) -> Int {
        if let table = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable {
            return getGlyphAssemblyParts(table, startOffset, &partsCount, &parts)
        }

        // FALL THRU
        partsCount = 0
        return 0
    }

    public func getGlyphAssemblyPartCount(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int = 0
    ) -> Int {
        getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable.map {
            let count = Int($0.partCount())
            return count - min(startOffset, count)
        } ?? 0
    }

    // MARK: - helper functions

    private func getMathGlyphConstructionTable(
        _ glyph: UInt16,
        _ direction: TextDirection
    ) -> MathGlyphConstructionTable? {
        if direction == .LTR || direction == .RTL {
            return mathVariantsTable?.getHorizGlyphConstructionTable(glyph)
        } else if direction == .BTT || direction == .TTB {
            return mathVariantsTable?.getVertGlyphConstructionTable(glyph)
        }
        return nil
    }

    @discardableResult
    private func getGlyphAssemblyParts(
        _ table: GlyphAssemblyTable,
        _ startOffset: Int,
        _ partsCount: inout Int,
        _ parts: inout [GlyphPart]
    ) -> Int {
        precondition(startOffset >= 0)
        precondition(partsCount >= 0)
        precondition(parts.count >= partsCount)

        let count = Int(table.partCount())
        let start = min(startOffset, count)
        let end = min(startOffset + partsCount, count)
        partsCount = end - start

        for i in 0 ..< partsCount {
            let j = start + i
            let record = table.partRecords(j)

            parts[i] = GlyphPart(glyph: record.glyphID,
                                 startConnectorLength: toPoints(record.startConnectorLength),
                                 endConnectorLength: toPoints(record.endConnectorLength),
                                 fullAdvance: toPoints(record.fullAdvance),
                                 flags: PartFlags(rawValue: record.partFlags) ?? .default)
        }

        return partsCount
    }
}

public struct MathKernEntry {
    public let maxCorrectionHeight: CGFloat
    public let kernValue: CGFloat

    init(maxCorrectionHeight: CGFloat, kernValue: CGFloat) {
        self.maxCorrectionHeight = maxCorrectionHeight
        self.kernValue = kernValue
    }

    init() {
        self.init(maxCorrectionHeight: 0, kernValue: 0)
    }
}

public struct MathGlyphVariant {
    /// The glyph index of the variant
    public let glyph: UInt16
    /// The advance width of the variant
    public let advance: CGFloat

    init(glyph: UInt16, advance: CGFloat) {
        self.glyph = glyph
        self.advance = advance
    }

    init() {
        self.init(glyph: 0, advance: 0)
    }
}

public struct GlyphPart {
    public let glyph: UInt16
    public let startConnectorLength: CGFloat
    public let endConnectorLength: CGFloat
    public let fullAdvance: CGFloat
    public let flags: PartFlags

    init(glyph: UInt16,
         startConnectorLength: CGFloat,
         endConnectorLength: CGFloat,
         fullAdvance: CGFloat,
         flags: PartFlags)
    {
        self.glyph = glyph
        self.startConnectorLength = startConnectorLength
        self.endConnectorLength = endConnectorLength
        self.fullAdvance = fullAdvance
        self.flags = flags
    }

    init() {
        self.init(glyph: 0, startConnectorLength: 0, endConnectorLength: 0, fullAdvance: 0, flags: .RESERVED)
    }

    public func isExtender() -> Bool {
        flags == PartFlags.EXTENDER_FLAG
    }
}
