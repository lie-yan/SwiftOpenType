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

    public func getConstant(_ index: MathConstant) -> Int32 {
        mathConstantsTable?.getMathConstant(index) ?? 0
    }

    // MARK: - MathGlyphInfo

    /// Returns the italics correction of the glyph or zero
    public func getGlyphItalicsCorrection(_ glyph: UInt16) -> Int32 {
        mathGlyphInfoTable?.mathItalicsCorrectionInfoTable?.getItalicsCorrection(glyph) ?? 0
    }

    /// Returns the top accent attachment of the glyph or 0.5 * the advance width of the glyph
    public func getGlyphTopAccentAttachment(_ glyph: UInt16) -> Int32 {
        if let value = mathGlyphInfoTable?.mathTopAccentAttachmentTable?.getTopAccentAttachment(glyph) {
            return value
        } else {
            return toDesignUnits(font.getAdvanceForGlyph(.horizontal, glyph) * 0.5)
        }
    }

    /// Returns requested kerning value or zero
    public func getGlyphKerning(_ glyph: UInt16,
                                _ corner: MathKernCorner,
                                _ correctionHeight: Int32) -> Int32
    {
        mathGlyphInfoTable?.mathKernInfoTable?.getKernValue(glyph, corner, correctionHeight) ?? 0
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

        guard let kernTable = mathGlyphInfoTable?.mathKernInfoTable?.getMathKernTable(glyph, corner) else {
            entriesCount = 0
            return 0
        }

        return kernTable.getKernEntries(startOffset, &entriesCount, &kernEntries)
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
    public func getMinConnectorOverlap(_: TextDirection) -> Int32 {
        let value = mathVariantsTable?.minConnectorOverlap()
        return Int32(value ?? 0)
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

        guard let table = getMathGlyphConstructionTable(glyph, direction) else {
            variantsCount = 0
            return 0
        }

        let count = Int(table.variantCount())
        let start = min(startOffset, count)
        let end = min(startOffset + variantsCount, count)
        variantsCount = end - start

        for i in 0 ..< variantsCount {
            let j = start + i
            let record = table.mathGlyphVariantRecord(j)

            variants[i] = MathGlyphVariant(glyph: record.variantGlyph,
                                           advance: Int32(record.advanceMeasurement))
        }
        return variantsCount
    }

    public func getGlyphVariantCount(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int = 0
    ) -> Int {
        precondition(startOffset >= 0)

        guard let table = getMathGlyphConstructionTable(glyph, direction) else {
            return 0
        }

        let count = Int(table.variantCount())
        return count - min(startOffset, count)
    }

    @discardableResult
    public func getGlyphAssembly(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int,
        _ partsCount: inout Int,
        _ parts: inout [GlyphPart],
        _ italicsCorrection: inout Int32
    ) -> Int {
        guard let table = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable else {
            partsCount = 0
            italicsCorrection = 0
            return 0
        }

        getGlyphAssemblyParts(table, startOffset, &partsCount, &parts)
        italicsCorrection = table.getItalicsCorrection()
        return partsCount
    }

    public func getGlyphAssemblyItalicsCorrection(
        _ glyph: UInt16,
        _ direction: TextDirection
    ) -> Int32 {
        getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable?.getItalicsCorrection() ?? 0
    }

    public func getGlyphAssemblyParts(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int,
        _ partsCount: inout Int,
        _ parts: inout [GlyphPart]
    ) -> Int {
        guard let table = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable else {
            partsCount = 0
            return 0
        }

        return getGlyphAssemblyParts(table, startOffset, &partsCount, &parts)
    }

    public func getGlyphAssemblyPartCount(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int = 0
    ) -> Int {
        guard let table = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable else {
            return 0
        }

        let count = Int(table.partCount())
        return count - min(startOffset, count)
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
                                 startConnectorLength: Int32(record.startConnectorLength),
                                 endConnectorLength: Int32(record.endConnectorLength),
                                 fullAdvance: Int32(record.fullAdvance),
                                 flags: PartFlags(rawValue: record.partFlags) ?? .default)
        }

        return partsCount
    }
}

public struct MathGlyphVariant {
    /// The glyph index of the variant
    public let glyph: UInt16
    /// The advance width of the variant
    public let advance: Int32

    init(glyph: UInt16, advance: Int32) {
        self.glyph = glyph
        self.advance = advance
    }

    init() {
        self.init(glyph: 0, advance: 0)
    }
}

public struct GlyphPart {
    public let glyph: UInt16
    public let startConnectorLength: Int32
    public let endConnectorLength: Int32
    public let fullAdvance: Int32
    public let flags: PartFlags

    init(glyph: UInt16,
         startConnectorLength: Int32,
         endConnectorLength: Int32,
         fullAdvance: Int32,
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
