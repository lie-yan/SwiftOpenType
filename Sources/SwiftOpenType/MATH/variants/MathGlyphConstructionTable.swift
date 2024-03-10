import CoreFoundation
class MathGlyphConstructionTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - header fields

    /// Offset to the GlyphAssembly table for this shape, from the beginning of the
    /// MathGlyphConstruction table. May be NULL.
    func glyphAssemblyOffset() -> Offset16 {
        readOffset16(base + 0)
    }

    /// Count of glyph growing variants for this glyph.
    func variantCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// MathGlyphVariantRecords for alternative variants of the glyphs.
    func mathGlyphVariantRecord(_ index: Int) -> MathGlyphVariantRecord {
        MathGlyphVariantRecord.read(base + 4 + index * MathGlyphVariantRecord.byteSize)
    }

    // MARK: - table

    var glyphAssemblyTable: GlyphAssemblyTable? {
        let offset = glyphAssemblyOffset()
        return (offset != 0)
            ? GlyphAssemblyTable(base: base + Int(offset), context: context)
            : nil
    }
}

class GlyphAssemblyTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Italics correction of this GlyphAssembly. Should not depend on the assembly size.
    func italicsCorrection() -> MathValueRecord {
        MathValueRecord.read(base + 0)
    }

    /// Number of parts in this assembly.
    func partCount() -> UInt16 {
        readUInt16(base + MathValueRecord.byteSize)
    }

    /// Array of part records, from left to right (for assemblies that extend
    /// horizontally) or bottom to top (for assemblies that extend vertically).
    func partRecords(_ index: Int) -> GlyphPartRecord {
        GlyphPartRecord.read(base + MathValueRecord.byteSize + 2 + index * GlyphPartRecord.byteSize)
    }

    // MARK: - Query functions

    func getItalicsCorrection() -> Int32 {
        MathValueRecord.eval(base, italicsCorrection(), context)
    }
}
