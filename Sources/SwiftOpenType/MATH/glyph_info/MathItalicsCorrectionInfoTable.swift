import CoreFoundation

public class MathItalicsCorrectionInfoTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData
    
    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }
    
    // MARK: - table fields
    
    /// Offset to Coverage table - from the beginning of MathItalicsCorrectionInfo table.
    public func italicsCorrectionCoverageOffset() -> Offset16 {
        readOffset16(base + 0)
    }
    
    /// Number of italics correction values. Should coincide with the number of covered glyphs.
    public func italicsCorrectionCount() -> UInt16 {
        readUInt16(base + 2)
    }
    
    /// Array of MathValueRecords defining italics correction values for each covered glyph.
    public func italicsCorrection(_ index: Int) -> MathValueRecord {
        MathValueRecord.read(base + 4 + index * MathValueRecord.byteSize)
    }
    
    // MARK: - Query function
            
    /// Returns italics correction for glyphID in design units
    public func getItalicsCorrection(_ glyph: UInt16) -> Int32 {
        if let index = self.coverageTable.getCoverageIndex(glyph) {
            return MathValueRecord.eval(base,
                                        self.italicsCorrection(index),
                                        context)
        }
        return 0
    }
    
    // MARK: - helper
    
    public var coverageTable: CoverageTable {
        self._coverageTable
    }
    
    private lazy var _coverageTable: CoverageTable = {
        CoverageTable(base: self.base + Int(self.italicsCorrectionCoverageOffset()))
    }()
}

