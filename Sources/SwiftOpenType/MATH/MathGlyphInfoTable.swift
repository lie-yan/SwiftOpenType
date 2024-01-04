import CoreText

public class MathGlyphInfoTable {
    let data: CFData
    let tableOffset: Offset16 /// offset from beginning of data

    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }

    // MARK: - Header fields

    /// Offset to MathItalicsCorrectionInfo table, from the beginning of the MathGlyphInfo table.
    public func mathItalicsCorrectionInfoOffset() -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 0)
    }

    /// Offset to MathTopAccentAttachment table, from the beginning of the MathGlyphInfo table.
    public func mathTopAccentAttachmentOffset() -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 2)
    }

    /// Offset to ExtendedShapes coverage table, from the beginning of the MathGlyphInfo table.
    /// When the glyph to the left or right of a box is an extended shape variant, the (ink) box
    /// should be used for vertical positioning purposes, not the default position defined by
    /// values in MathConstants table. May be NULL.
    var extendedShapeCoverageOffset: Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 4)
    }

    /// Offset to MathKernInfo table, from the beginning of the MathGlyphInfo table.
    var mathKernInfoOffset: Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 6)
    }

    // MARK: - Sub-tables

    public var mathItalicsCorrectionInfoTable: MathItalicsCorrectionInfoTable? {
        let subtableOffset = mathItalicsCorrectionInfoOffset()
        
        if subtableOffset != 0 {
            return MathItalicsCorrectionInfoTable(data: data, tableOffset: self.tableOffset + subtableOffset)
        }
        return nil
    }
    
    public var mathTopAccentAttachmentTable: MathTopAccentAttachmentTable? {
        let subtableOffset = mathTopAccentAttachmentOffset()
        
        if subtableOffset != 0 {
            return MathTopAccentAttachmentTable(data: data, tableOffset: self.tableOffset + subtableOffset)
        }
        return nil
    }
}

public class MathItalicsCorrectionInfoTable {
    let data: CFData
    let tableOffset: Offset16 /// offset from the beginning of MATH table
    
    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }

    /// Offset to Coverage table - from the beginning of MathItalicsCorrectionInfo table.
    public func italicsCorrectionCoverageOffset() -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 0)
    }

    /// Number of italics correction values. Should coincide with the number of covered glyphs.
    public func italicsCorrectionCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }

    /// Array of MathValueRecords defining italics correction values for each covered glyph.
    public func italicsCorrection(_ index: Int) -> MathValueRecord {
        data.readMathValueRecord(parentOffset: tableOffset, offset: 4 + index * MathValueRecord.byteSize)
    }

    public func coverageTable() -> CoverageTable {
        CoverageTable(data: data, tableOffset: tableOffset + italicsCorrectionCoverageOffset())
    }

    /// Return italics correction for glyphID in design units
    public func getItalicsCorrection(_ glyphID: UInt16) -> Int32 {
        let coverageTable = self.coverageTable()
        if let coverageIndex = coverageTable.getCoverageIndex(glyphID) {
            let mathValueRecord = italicsCorrection(coverageIndex)
            let value = data.evalMathValueRecord(parentOffset: tableOffset,
                                                 mathValueRecord: mathValueRecord)
            return value
        }
        return 0
    }
}

public class MathTopAccentAttachmentTable {
    let data: CFData
    let tableOffset: Offset16 /// offset from the beginning of MATH table

    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }
    
    /// Offset to Coverage table, from the beginning of the MathTopAccentAttachment table.
    public func topAccentCoverageOffset() -> Offset16 {
        data.readOffset16(parentOffset: tableOffset, offset: 0)
    }

    /// Number of top accent attachment point values. Must be the same as the number of
    /// glyph IDs referenced in the Coverage table.
    public func topAccentAttachmentCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }
        
    /// Array of MathValueRecords defining top accent attachment points for each covered glyph.
    public func topAccentAttachment(_ index: Int) -> MathValueRecord {
        data.readMathValueRecord(parentOffset: tableOffset, offset: 4 + index * MathValueRecord.byteSize)
    }
    
    public func coverageTable() -> CoverageTable {
        CoverageTable(data: data, tableOffset: tableOffset + topAccentCoverageOffset())
    }

    /// Return top accent attachment for glyphID in design units
    public func getTopAccentAttachment(_ glyphID: UInt16) -> Int32 {
        let coverageTable = self.coverageTable()
        if let coverageIndex = coverageTable.getCoverageIndex(glyphID) {
            let mathValueRecord = topAccentAttachment(coverageIndex)
            let value = data.evalMathValueRecord(parentOffset: tableOffset,
                                                 mathValueRecord: mathValueRecord)
            return value
        }
        return 0
    }
}
