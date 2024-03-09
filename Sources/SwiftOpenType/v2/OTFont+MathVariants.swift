import CoreFoundation

public extension OTFont {
    /// Returns requested minimum connector overlap or zero
    func getMinConnectorOverlap(_: TextDirection) -> CGFloat {
        let value = mathTable?.mathVariantsTable?.minConnectorOverlap()
        return CGFloat(value ?? 0) * sizePerUnit
    }

    @discardableResult
    func getGlyphVariants(
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
                                               advance: CGFloat(record.advanceMeasurement) * sizePerUnit)
            }
            return variantsCount
        }

        // FALL THRU
        variantsCount = 0
        return 0
    }

    func getGlyphVariantCount(
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
    func getGlyphAssembly(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int,
        _ partsCount: inout Int,
        _ parts: inout [GlyphPart],
        _ italicsCorrection: inout CGFloat
    ) -> Int {
        if let table = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable {
            getGlyphAssemblyParts(table, startOffset, &partsCount, &parts)
            italicsCorrection = CGFloat(table.getItalicsCorrection()) * sizePerUnit
            return partsCount
        }

        // FALL THRU
        partsCount = 0
        italicsCorrection = 0
        return 0
    }

    func getGlyphAssemblyItalicsCorrection(
        _ glyph: UInt16,
        _ direction: TextDirection
    ) -> CGFloat {
        let value = getMathGlyphConstructionTable(glyph, direction)?.glyphAssemblyTable?.getItalicsCorrection()
        return CGFloat(value ?? 0) * sizePerUnit
    }

    func getGlyphAssemblyParts(
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

    func getGlyphAssemblyPartsCount(
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
            return mathTable?.mathVariantsTable?.getHorizGlyphConstructionTable(glyph)
        } else if direction == .BTT || direction == .TTB {
            return mathTable?.mathVariantsTable?.getVertGlyphConstructionTable(glyph)
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
            let record = table.partRecords(index: j)

            parts[i] = GlyphPart(glyph: record.glyphID,
                                 startConnectorLength: CGFloat(record.startConnectorLength) * sizePerUnit,
                                 endConnectorLength: CGFloat(record.endConnectorLength) * sizePerUnit,
                                 fullAdvance: CGFloat(record.fullAdvance) * sizePerUnit,
                                 flags: PartFlags(rawValue: record.partFlags) ?? .default)
        }

        return partsCount
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
