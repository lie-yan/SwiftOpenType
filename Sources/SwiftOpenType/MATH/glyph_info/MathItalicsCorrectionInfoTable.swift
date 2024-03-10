import CoreFoundation
class MathItalicsCorrectionInfoTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Offset to Coverage table - from the beginning of MathItalicsCorrectionInfo table.
    func italicsCorrectionCoverageOffset() -> Offset16 {
        readOffset16(base + 0)
    }

    /// Number of italics correction values. Should coincide with the number of covered glyphs.
    func italicsCorrectionCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of MathValueRecords defining italics correction values for each covered glyph.
    func italicsCorrection(_ index: Int) -> MathValueRecord {
        MathValueRecord.read(base + 4 + index * MathValueRecord.byteSize)
    }

    // MARK: - Query function

    /// Returns italics correction for glyphID in design units
    func getItalicsCorrection(_ glyph: UInt16) -> Int32 {
        if let index = italicsCorrectionCoverageTable.getCoverageIndex(glyph) {
            return MathValueRecord.eval(base,
                                        italicsCorrection(index),
                                        context)
        }
        return 0
    }

    // MARK: - helper

    private lazy var italicsCorrectionCoverageTable: CoverageTable = .init(base: self.base + Int(self.italicsCorrectionCoverageOffset()))
}
