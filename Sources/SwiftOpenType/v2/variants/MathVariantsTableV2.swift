import CoreFoundation

public class MathVariantsTableV2 {
    let base: UnsafePointer<UInt8>

    init(base: UnsafePointer<UInt8>) {
        self.base = base
    }

    // MARK: - Table fields

    /// Minimum overlap of connecting glyphs during glyph construction, in design units.
    public func minConnectorOverlap() -> UFWORD {
        readUFWORD(base + 0)
    }

    /// Offset to Coverage table, from the beginning of the MathVariants table.
    public func vertGlyphCoverageOffset() -> Offset16 {
        readOffset16(base + 2)
    }

    /// Offset to Coverage table, from the beginning of the MathVariants table.
    public func horizGlyphCoverageOffset() -> Offset16 {
        readOffset16(base + 4)
    }

    /// Number of glyphs for which information is provided for vertically growing variants.
    /// Must be the same as the number of glyph IDs referenced in the vertical Coverage table.
    public func vertGlyphCount() -> UInt16 {
        readUInt16(base + 6)
    }

    /// Number of glyphs for which information is provided for horizontally growing variants.
    /// Must be the same as the number of glyph IDs referenced in the horizontal Coverage table.
    public func horizGlyphCount() -> UInt16 {
        readUInt16(base + 8)
    }

    /// Array of offsets to MathGlyphConstruction tables, from the beginning of the
    /// MathVariants table, for shapes growing in the vertical direction.
    public func vertGlyphConstructionOffsets(index: Int) -> Offset16 {
        readOffset16(base + 10 + index * 2)
    }

    /// Array of offsets to MathGlyphConstruction tables, from the beginning of the
    /// MathVariants table, for shapes growing in the horizontal direction.
    public func horizGlyphConstructionOffsets(index: Int) -> Offset16 {
        let vertGlyphCount = self.vertGlyphCount()
        let offset = 10 + Int(vertGlyphCount) * 2 + index * 2
        return readOffset16(base + offset)
    }

    // MARK: - Sub-tables

    public var vertGlyphCoverageTable: CoverageTableV2 {
        CoverageTableV2(base: base + Int(vertGlyphCoverageOffset()))
    }

    public var horizGlyphCoverageTable: CoverageTableV2 {
        CoverageTableV2(base: base + Int(horizGlyphCoverageOffset()))
    }

//    public func vertGlyphConstructionTable(index: Int) -> MathGlyphConstructionTable {
//        let subtableOffset = self.vertGlyphConstructionOffsets(index: index)
//        return MathGlyphConstructionTable(data: data, tableOffset: tableOffset + subtableOffset)
//    }
//
//    public func horizGlyphConstructionTable(index: Int) -> MathGlyphConstructionTable {
//        let subtableOffset = self.horizGlyphConstructionOffsets(index: index)
//        return MathGlyphConstructionTable(data: data, tableOffset: tableOffset + subtableOffset)
//    }
//
//    // MARK: - Query functions
//
//    public func getVertGlyphConstructionTable(glyphID: UInt16) -> MathGlyphConstructionTable? {
//        let coverageTable = self.vertGlyphCoverageTable
//        if let coverageIndex = coverageTable.getCoverageIndex(glyphID: glyphID) {
//            return self.vertGlyphConstructionTable(index: coverageIndex)
//        }
//        return nil
//    }
//
//    public func getHorizGlyphConstructionTable(glyphID: UInt16) -> MathGlyphConstructionTable? {
//        let coverageTable = self.horizGlyphCoverageTable
//        if let coverageIndex = coverageTable.getCoverageIndex(glyphID: glyphID) {
//            return self.horizGlyphConstructionTable(index: coverageIndex)
//        }
//        return nil
//    }
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
}
