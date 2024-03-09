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

        if direction == .LTR || direction == .RTL {
            if let table = mathTable?.mathVariantsTable?.getHorizGlyphConstructionTable(glyph) {
                return getGlyphVariants(table, startOffset, &variantsCount, &variants)
            }
        } else if direction == .TTB || direction == .BTT {
            if let table = mathTable?.mathVariantsTable?.getVertGlyphConstructionTable(glyph) {
                return getGlyphVariants(table, startOffset, &variantsCount, &variants)
            }
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
        if direction == .LTR || direction == .RTL {
            if let table = mathTable?.mathVariantsTable?.getHorizGlyphConstructionTable(glyph) {
                return getGlyphVariantCount(table, startOffset)
            }
        } else if direction == .BTT || direction == .TTB {
            if let table = mathTable?.mathVariantsTable?.getVertGlyphConstructionTable(glyph) {
                return getGlyphVariantCount(table, startOffset)
            }
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
        if direction == .LTR || direction == .RTL {
            if let table = mathTable?.mathVariantsTable?.getHorizGlyphConstructionTable(glyph)?.glyphAssemblyTable {
                return getGlyphAssembly(table, startOffset, &partsCount, &parts, &italicsCorrection)
            }
        } else if direction == .BTT || direction == .TTB {
            if let table = mathTable?.mathVariantsTable?.getVertGlyphConstructionTable(glyph)?.glyphAssemblyTable {
                return getGlyphAssembly(table, startOffset, &partsCount, &parts, &italicsCorrection)
            }
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
        if direction == .LTR || direction == .RTL {
            if let table = mathTable?.mathVariantsTable?.getHorizGlyphConstructionTable(glyph)?.glyphAssemblyTable {
                return getGlyphAssemblyPartsCount(table, startOffset)
            }
        } else if direction == .BTT || direction == .TTB {
            if let table = mathTable?.mathVariantsTable?.getVertGlyphConstructionTable(glyph)?.glyphAssemblyTable {
                return getGlyphAssemblyPartsCount(table, startOffset)
            }
        }

        // FALL THRU
        return 0
    }

    // MARK: - helper functions

    private func getGlyphVariants(_ table: MathGlyphConstructionTableV2,
                                  _ startOffset: Int,
                                  _ variantsCount: inout Int,
                                  _ variants: inout [MathGlyphVariant]) -> Int
    {
        precondition(startOffset >= 0)
        precondition(variantsCount >= 0)
        precondition(variants.count >= variantsCount)

        let count = Int(table.variantCount())
        let start = min(startOffset, count)
        let end = min(startOffset + variantsCount, count)
        variantsCount = end - start

        for i in 0 ..< variantsCount {
            let j = start + i
            let record = table.mathGlyphVariantRecord(index: j)

            variants[i] = MathGlyphVariant(glyph: record.variantGlyph,
                                           advance: CGFloat(record.advanceMeasurement) * sizePerUnit)
        }
        return variantsCount
    }

    private func getGlyphVariantCount(_ table: MathGlyphConstructionTableV2,
                                      _ startOffset: Int) -> Int
    {
        precondition(startOffset >= 0)
        let count = Int(table.variantCount())
        return count - min(startOffset, count)
    }

    private func getGlyphAssembly(
        _ table: GlyphAssemblyTableV2,
        _ startOffset: Int,
        _ partsCount: inout Int,
        _ parts: inout [GlyphPart],
        _ italicsCorrection: inout CGFloat
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

        italicsCorrection = CGFloat(table.getItalicsCorrection()) * sizePerUnit

        return partsCount
    }

    private func getGlyphAssemblyPartsCount(
        _ table: GlyphAssemblyTableV2,
        _ startOffset: Int
    ) -> Int {
        precondition(startOffset >= 0)
        let count = Int(table.partCount())
        return count - min(startOffset, count)
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
