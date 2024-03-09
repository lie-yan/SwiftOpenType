import CoreFoundation

/// The MATH table
public class MathTable {
    let data: CFData

    init(data: CFData) {
        self.data = data
    }

    // MARK: - Header fields

    /// Major version of the MATH table, = 1.
    public func majorVersion() -> UInt16 {
        data.readUInt16(0)
    }

    /// Minor version of the MATH table, = 0.
    public func minorVersion() -> UInt16 {
        data.readUInt16(2)
    }

    /// Offset to MathConstants table - from the beginning of MATH table.
    public func mathConstantsOffset() -> Offset16 {
        data.readOffset16(4)
    }

    /// Offset to MathGlyphInfo table - from the beginning of MATH table.
    public func mathGlyphInfoOffset() -> Offset16 {
        data.readOffset16(6)
    }

    /// Offset to MathVariants table - from the beginning of MATH table.
    public func mathVariantsOffset() -> Offset16 {
        data.readOffset16(8)
    }

    // MARK: - Sub-tables

//    public var mathConstantsTable: MathConstantsTable? {
//        let tableOffset = mathConstantsOffset()
//        if tableOffset != 0 {
//            return MathConstantsTable(data: data, tableOffset: tableOffset)
//        }
//        return nil
//    }

//    public var mathGlyphInfoTable: MathGlyphInfoTable? {
//        let tableOffset = mathGlyphInfoOffset()
//        if tableOffset != 0 {
//            return MathGlyphInfoTable(data: data, tableOffset: tableOffset)
//        }
//        return nil
//    }
}

