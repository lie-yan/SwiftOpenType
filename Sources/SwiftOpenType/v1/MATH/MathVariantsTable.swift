import CoreFoundation

public class MathVariantsTable {
    let data: CFData
    let tableOffset: Offset16 /// offset from beginning of data

    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }

    // MARK: - Table fields

    /// Minimum overlap of connecting glyphs during glyph construction, in design units.
    public func minConnectorOverlap() -> UFWORD {
        data.readUFWORD(parentOffset: tableOffset, offset: 0)
    }

    /// Offset to Coverage table, from the beginning of the MathVariants table.
    public func vertGlyphCoverageOffset() -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 2)
    }

    /// Offset to Coverage table, from the beginning of the MathVariants table.
    public func horizGlyphCoverageOffset() -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 4)
    }

    /// Number of glyphs for which information is provided for vertically growing variants.
    /// Must be the same as the number of glyph IDs referenced in the vertical Coverage table.
    public func vertGlyphCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 6)
    }

    /// Number of glyphs for which information is provided for horizontally growing variants.
    /// Must be the same as the number of glyph IDs referenced in the horizontal Coverage table.
    public func horizGlyphCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 8)
    }

    /// Array of offsets to MathGlyphConstruction tables, from the beginning of the
    /// MathVariants table, for shapes growing in the vertical direction.
    public func vertGlyphConstructionOffsets(index: Int) -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 10 + index * 2)
    }

    /// Array of offsets to MathGlyphConstruction tables, from the beginning of the
    /// MathVariants table, for shapes growing in the horizontal direction.
    public func horizGlyphConstructionOffsets(index: Int) -> Offset16 {
        let vertGlyphCount = self.vertGlyphCount()
        let offset = 10 + Int(vertGlyphCount) * 2 + index * 2
        return data.readOffset16(parentOffset: tableOffset, offset: offset)
    }

    // MARK: - Sub-tables

    public var vertGlyphCoverageTable: CoverageTable {
        return CoverageTable(data: data, tableOffset: tableOffset + vertGlyphCoverageOffset())
    }

    public var horizGlyphCoverageTable: CoverageTable {
        return CoverageTable(data: data, tableOffset: tableOffset + horizGlyphCoverageOffset())
    }

    public func vertGlyphConstructionTable(index: Int) -> MathGlyphConstructionTable {
        let subtableOffset = vertGlyphConstructionOffsets(index: index)
        return MathGlyphConstructionTable(data: data, tableOffset: tableOffset + subtableOffset)
    }

    public func horizGlyphConstructionTable(index: Int) -> MathGlyphConstructionTable {
        let subtableOffset = horizGlyphConstructionOffsets(index: index)
        return MathGlyphConstructionTable(data: data, tableOffset: tableOffset + subtableOffset)
    }

    // MARK: - Query functions

    public func getVertGlyphConstructionTable(glyphID: UInt16) -> MathGlyphConstructionTable? {
        let coverageTable = vertGlyphCoverageTable
        if let coverageIndex = coverageTable.getCoverageIndex(glyphID: glyphID) {
            return vertGlyphConstructionTable(index: coverageIndex)
        }
        return nil
    }

    public func getHorizGlyphConstructionTable(glyphID: UInt16) -> MathGlyphConstructionTable? {
        let coverageTable = horizGlyphCoverageTable
        if let coverageIndex = coverageTable.getCoverageIndex(glyphID: glyphID) {
            return horizGlyphConstructionTable(index: coverageIndex)
        }
        return nil
    }
}

public class MathGlyphConstructionTable {
    let data: CFData
    let tableOffset: Offset16 // offset from beginning of data

    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }

    // MARK: - Table fields

    /// Offset to the GlyphAssembly table for this shape, from the beginning of the
    /// MathGlyphConstruction table. May be NULL.
    public func glyphAssemblyOffset() -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 0)
    }

    /// Count of glyph growing variants for this glyph.
    public func variantCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }

    /// MathGlyphVariantRecords for alternative variants of the glyphs.
    public func mathGlyphVariantRecord(index: Int) -> MathGlyphVariantRecord {
        let offset = Int(tableOffset) + 4 + index * MathGlyphVariantRecord.byteSize
        return MathGlyphVariantRecord.read(data: data, offset: offset)
    }

    // MARK: - Sub-tables

    public var glyphAssemblyTable: GlyphAssemblyTable? {
        let subtableOffset = glyphAssemblyOffset()

        if subtableOffset != 0 {
            return GlyphAssemblyTable(data: data, tableOffset: tableOffset + subtableOffset)
        }
        return nil
    }
}

public class GlyphAssemblyTable {
    let data: CFData
    let tableOffset: Offset16

    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }

    // MARK: - table fields

    /// Italics correction of this GlyphAssembly. Should not depend on the assembly size.
    public func italicsCorrection() -> MathValueRecord {
        MathValueRecord.read(data: data, parentOffset: tableOffset, offset: 0)
    }

    /// Number of parts in this assembly.
    public func partCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }

    /// Array of part records, from left to right (for assemblies that extend
    /// horizontally) or bottom to top (for assemblies that extend vertically).
    public func partRecords(index: Int) -> GlyphPartRecord {
        let offset = Int(tableOffset) + 4 + index * GlyphPartRecord.byteSize
        return GlyphPartRecord.read(data: data, offset: offset)
    }

    // MARK: - Query functions

    public func getItalicsCorrection() -> Int32 {
        let mathValueRecord = italicsCorrection()
        let value = data.evalMathValueRecord(parentOffset: tableOffset, mathValueRecord: mathValueRecord)
        return value
    }
}
