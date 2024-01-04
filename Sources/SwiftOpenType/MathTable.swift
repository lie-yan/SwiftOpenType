import CoreText

/**
 The MATH table
 */
public class MathTable {
    let font: CTFont
    let data: CFData

    init(font: CTFont) {
        self.font = font
        self.data = font.getMathTableData()!
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

    public var mathConstantsTable: MathConstantsTable? {
        let tableOffset = mathConstantsOffset()
        if tableOffset != 0 {
            return MathConstantsTable(data: data, tableOffset: tableOffset)
        }
        return nil
    }

    public var mathGlyphInfoTable: MathGlyphInfoTable? {
        let tableOffset = mathGlyphInfoOffset()
        if tableOffset != 0 {
            return MathGlyphInfoTable(data: data, tableOffset: tableOffset)
        }
        return nil
    }
}

public struct MathValueRecord {
    static let byteSize = 4

    public let value: FWORD           // The X or Y value in design units
    public let deviceOffset: Offset16 // Offset to the device table — from the beginning of parent table.
                                      // May be NULL. Suggested format for device table is 1.

    init() {
        self.init(value: 0, deviceOffset: 0)
    }

    init(value: FWORD, deviceOffset: Offset16) {
        self.value = value
        self.deviceOffset = deviceOffset
    }
}
