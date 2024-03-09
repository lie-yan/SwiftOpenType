import CoreFoundation

public class MathVariantsTableV2 {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
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
    public func vertGlyphConstructionOffsets(_ index: Int) -> Offset16 {
        readOffset16(base + 10 + index * 2)
    }

    /// Array of offsets to MathGlyphConstruction tables, from the beginning of the
    /// MathVariants table, for shapes growing in the horizontal direction.
    public func horizGlyphConstructionOffsets(_ index: Int) -> Offset16 {
        let offset = 10 + Int(vertGlyphCount()) * 2 + index * 2
        return readOffset16(base + offset)
    }

    // MARK: - Tables

    public var vertGlyphCoverageTable: CoverageTableV2 {
        CoverageTableV2(base: base + Int(vertGlyphCoverageOffset()))
    }

    public var horizGlyphCoverageTable: CoverageTableV2 {
        CoverageTableV2(base: base + Int(horizGlyphCoverageOffset()))
    }

    public func vertGlyphConstructionTable(_ index: Int) -> MathGlyphConstructionTableV2 {
        let offset = vertGlyphConstructionOffsets(index)
        return MathGlyphConstructionTableV2(base: base + Int(offset), context: context)
    }

    public func horizGlyphConstructionTable(_ index: Int) -> MathGlyphConstructionTableV2 {
        let offset = horizGlyphConstructionOffsets(index)
        return MathGlyphConstructionTableV2(base: base + Int(offset), context: context)
    }

    // MARK: - Query functions

    public func getVertGlyphConstructionTable(_ glyph: UInt16) -> MathGlyphConstructionTableV2? {
        vertGlyphCoverageTable.getCoverageIndex(glyph).map {
            self.vertGlyphConstructionTable($0)
        }
    }

    public func getHorizGlyphConstructionTable(_ glyph: UInt16) -> MathGlyphConstructionTableV2? {
        horizGlyphCoverageTable.getCoverageIndex(glyph).map {
            self.horizGlyphConstructionTable($0)
        }
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

    // Deprecated
    static func read(data: CFData, offset: Int) -> MathGlyphVariantRecord {
        let variantGlyph = data.readUInt16(offset)
        let advanceMeasurement = data.readUFWORD(offset + 2)
        return MathGlyphVariantRecord(variantGlyph: variantGlyph, advanceMeasurement: advanceMeasurement)
    }

    static func read(_ ptr: UnsafePointer<UInt8>) -> MathGlyphVariantRecord {
        MathGlyphVariantRecord(variantGlyph: readUInt16(ptr + 0),
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
         partFlags: UInt16)
    {
        self.glyphID = glyphID
        self.startConnectorLength = startConnectorLength
        self.endConnectorLength = endConnectorLength
        self.fullAdvance = fullAdvance
        self.partFlags = partFlags
    }

    public func isExtender() -> Bool {
        partFlags == PartFlags.EXTENDER_FLAG.rawValue
    }

    // Deprecated
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

    static func read(_ ptr: UnsafePointer<UInt8>) -> GlyphPartRecord {
        GlyphPartRecord(glyphID: readUInt16(ptr),
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
