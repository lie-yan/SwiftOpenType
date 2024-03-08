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
        let subtableOffset = self.vertGlyphConstructionOffsets(index: index)
        return MathGlyphConstructionTable(data: data, tableOffset: tableOffset + subtableOffset)
    }
    
    public func horizGlyphConstructionTable(index: Int) -> MathGlyphConstructionTable {
        let subtableOffset = self.horizGlyphConstructionOffsets(index: index)
        return MathGlyphConstructionTable(data: data, tableOffset: tableOffset + subtableOffset)
    }
    
    // MARK: - Query functions
    
    public func getVertGlyphConstructionTable(glyphID: UInt16) -> MathGlyphConstructionTable? {
        let coverageTable = self.vertGlyphCoverageTable
        if let coverageIndex = coverageTable.getCoverageIndex(glyphID: glyphID) {
            return self.vertGlyphConstructionTable(index: coverageIndex)
        }
        return nil
    }
    
    public func getHorizGlyphConstructionTable(glyphID: UInt16) -> MathGlyphConstructionTable? {
        let coverageTable = self.horizGlyphCoverageTable
        if let coverageIndex = coverageTable.getCoverageIndex(glyphID: glyphID) {
            return self.horizGlyphConstructionTable(index: coverageIndex)
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
        let subtableOffset = self.glyphAssemblyOffset()
        
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
        let mathValueRecord = self.italicsCorrection()
        let value = data.evalMathValueRecord(parentOffset: tableOffset, mathValueRecord: mathValueRecord)
        return value
    }
}

public struct MathGlyphVariantRecord {
    static let byteSize = 4

    /// Glyph ID for the variant.
    public let variantGlyph: UInt16
    /// Advance width/height, in design units, of the variant, in the direction of requested glyph extension.
    public let advanceMeasurement: UFWORD
    
    init() {
        self.init(variantGlyph: 0, advanceMeasurement: 0)
    }
    
    init(variantGlyph: UInt16, advanceMeasurement: UFWORD) {
        self.variantGlyph = variantGlyph
        self.advanceMeasurement = advanceMeasurement
    }
    
    static func read(data: CFData, offset: Int) -> MathGlyphVariantRecord {
        let variantGlyph = data.readUInt16(offset)
        let advanceMeasurement = data.readUFWORD(offset + 2)
        return MathGlyphVariantRecord(variantGlyph: variantGlyph, advanceMeasurement: advanceMeasurement)
    }
    
    static func read(ptr: UnsafePointer<UInt8>) -> MathGlyphVariantRecord {
        return MathGlyphVariantRecord(variantGlyph: readUInt16(ptr + 0),
                                      advanceMeasurement: readUFWORD(ptr + 2))
    }
}

public struct GlyphPartRecord {
    static let byteSize = 10

    /// Glyph ID for the part.
    public let glyphID: UInt16
    
    /// Advance width/ height, in design units, of the straight bar connector material 
    /// at the start of the glyph in the direction of the extension (the left end for
    /// horizontal extension, the bottom end for vertical extension).
    public let startConnectorLength: UFWORD
    
    /// Advance width/ height, in design units, of the straight bar connector material 
    /// at the end of the glyph in the direction of the extension (the right end for
    /// horizontal extension, the top end for vertical extension).
    public let endConnectorLength: UFWORD
    
    /// Full advance width/height for this part in the direction of the extension,
    /// in design units.
    public let fullAdvance: UFWORD
    
    /// Part qualifiers. PartFlags enumeration currently uses only one bit:
    /// 0x0001 EXTENDER_FLAG: If set, the part can be skipped or repeated.
    /// 0xFFFE Reserved.
    public let partFlags: UInt16
    
    init() {
        self.init(glyphID: 0, startConnectorLength: 0, endConnectorLength: 0, fullAdvance: 0, partFlags: 0)
    }
    
    init(glyphID: UInt16, 
         startConnectorLength: UFWORD,
         endConnectorLength: UFWORD,
         fullAdvance: UFWORD,
         partFlags: UInt16) {
        self.glyphID = glyphID
        self.startConnectorLength = startConnectorLength
        self.endConnectorLength = endConnectorLength
        self.fullAdvance = fullAdvance
        self.partFlags = partFlags
    }
    
    public func isExtender() -> Bool {
        self.partFlags == PartFlags.EXTENDER_FLAG.rawValue
    }
        
    static func read(data: CFData, offset: Int) -> GlyphPartRecord {
        let glyphID = data.readUInt16(offset)
        let startConnectorLength = data.readUFWORD(offset + 2)
        let endConnectorLength = data.readUFWORD(offset + 4)
        let fullAdvance = data.readUFWORD(offset + 6)
        let partFlags = data.readUInt16(offset + 8)
        
        return GlyphPartRecord(glyphID: glyphID,
                               startConnectorLength: startConnectorLength,
                               endConnectorLength: endConnectorLength,
                               fullAdvance: fullAdvance,
                               partFlags: partFlags)
    }
    
    static func read(ptr: UnsafePointer<UInt8>) -> GlyphPartRecord {
        return GlyphPartRecord(glyphID: readUInt16(ptr),
                               startConnectorLength: readUFWORD(ptr + 2),
                               endConnectorLength: readUFWORD(ptr + 4),
                               fullAdvance: readUFWORD(ptr + 6),
                               partFlags: readUInt16(ptr + 8))
    }
}

public enum PartFlags: UInt16 {
    case EXTENDER_FLAG = 0x0001
    case RESERVED = 0xFFFE
}

public enum TextOrientation: UInt32 {
    case `default` = 0
    case horizontal = 1
    case vertical = 2
}

public enum TextDirection: UInt32 {
    case Invalid = 0
    case LTR = 1
    case RTL = 2
    case TTB = 3
    case BTT = 4
}
