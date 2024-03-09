import CoreFoundation

public class MathGlyphConstructionTableV2 {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - header fields

    /// Offset to the GlyphAssembly table for this shape, from the beginning of the
    /// MathGlyphConstruction table. May be NULL.
    public func glyphAssemblyOffset() -> Offset16 {
        readOffset16(base + 0)
    }

    /// Count of glyph growing variants for this glyph.
    public func variantCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// MathGlyphVariantRecords for alternative variants of the glyphs.
    public func mathGlyphVariantRecord(index: Int) -> MathGlyphVariantRecord {
        MathGlyphVariantRecord.read(base + 4 + index * MathGlyphVariantRecord.byteSize)
    }

    // MARK: - table

    public var glyphAssemblyTable: GlyphAssemblyTableV2? {
        let offset = glyphAssemblyOffset()
        return (offset != 0)
            ? GlyphAssemblyTableV2(base: base + Int(offset), context: context)
            : nil
    }
}

public class GlyphAssemblyTableV2 {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Italics correction of this GlyphAssembly. Should not depend on the assembly size.
    public func italicsCorrection() -> MathValueRecord {
        MathValueRecord.read(base + 0)
    }

    /// Number of parts in this assembly.
    public func partCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of part records, from left to right (for assemblies that extend
    /// horizontally) or bottom to top (for assemblies that extend vertically).
    public func partRecords(index: Int) -> GlyphPartRecord {
        GlyphPartRecord.read(base + 4 + index * GlyphPartRecord.byteSize)
    }

    // MARK: - Query functions

    public func getItalicsCorrection() -> Int32 {
        MathValueRecord.eval(base, italicsCorrection(), context)
    }
}
