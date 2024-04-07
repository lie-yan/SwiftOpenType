import CoreFoundation

/// Represents a mathematical table.
class MathTable {
    /// Pointer to the beginning of the table data.
    let base: UnsafePointer<UInt8>
    /// Contextual data for the table.
    let context: ContextData

    /// Initializes a `MathTable` instance.
    /// - Parameters:
    ///   - base: Pointer to the beginning of the table data.
    ///   - context: Contextual data for the table.
    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - Header Fields

    /// Returns the major version of the MATH table. Expected to be 1.
    func majorVersion() -> UInt16 { readUInt16(base + 0) }

    /// Returns the minor version of the MATH table. Expected to be 0.
    func minorVersion() -> UInt16 { readUInt16(base + 2) }

    /// Returns the offset to MathConstants table from the beginning of MATH table.
    func mathConstantsOffset() -> Offset16 { readOffset16(base + 4) }

    /// Returns the offset to MathGlyphInfo table from the beginning of MATH table.
    func mathGlyphInfoOffset() -> Offset16 { readOffset16(base + 6) }

    /// Returns the offset to MathVariants table from the beginning of MATH table.
    func mathVariantsOffset() -> Offset16 { readOffset16(base + 8) }

    // MARK: - Tables

    /// MathConstants table.
    var mathConstantsTable: MathConstantsTable? { _mathConstantsTable }

    /// MathGlyphInfo table.
    var mathGlyphInfoTable: MathGlyphInfoTable? { _mathGlyphInfoTable }

    /// MathVariants table.
    var mathVariantsTable: MathVariantsTable? { _mathVariantsTable }

    // MARK: - Lazy Variables

    /// Lazy variable for MathConstants table.
    private lazy var _mathConstantsTable: MathConstantsTable? = {
        let offset = self.mathConstantsOffset()
        return (offset != 0)
            ? MathConstantsTable(base: base + Int(offset), context: context)
            : nil
    }()

    /// Lazy variable for MathGlyphInfo table.
    private lazy var _mathGlyphInfoTable: MathGlyphInfoTable? = {
        let offset = self.mathGlyphInfoOffset()
        return (offset != 0)
            ? MathGlyphInfoTable(base: base + Int(offset), context: context)
            : nil
    }()

    /// Lazy variable for MathVariants table.
    private lazy var _mathVariantsTable: MathVariantsTable? = {
        let offset = self.mathVariantsOffset()
        return (offset != 0)
            ? MathVariantsTable(base: base + Int(offset), context: context)
            : nil
    }()
}

/// Enumeration representing delta formats for device and variation index tables. [Learn more](https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#device-and-variationindex-tables)
enum DeltaFormat: UInt16 {
    /// Signed 2-bit value, 8 values per uint16.
    case LOCAL_2_BIT_DELTAS = 0x0001

    /// Signed 4-bit value, 4 values per uint16.
    case LOCAL_4_BIT_DELTAS = 0x0002

    /// Signed 8-bit value, 2 values per uint16.
    case LOCAL_8_BIT_DELTAS = 0x0003

    /// VariationIndex table, contains a delta-set index pair.
    case VARIATION_INDEX = 0x8000

    /// For future use — set to 0.
    case Reserved = 0x7FFC
}

/// Represents a mathematical value record.
struct MathValueRecord {
    /// Size of a value record in bytes.
    static let byteSize = 4
    /// The X or Y value in design units.
    let value: FWORD
    /// Offset to the device table from the beginning of parent table. May be NULL. Suggested format for device table is 1.
    let deviceOffset: Offset16

    /// Initializes a MathValueRecord instance.
    init() { self.init(value: 0, deviceOffset: 0) }

    /// Initializes a MathValueRecord instance with the provided values.
    /// - Parameters:
    ///   - value: The X or Y value in design units.
    ///   - deviceOffset: Offset to the device table from the beginning of parent table.
    init(value: FWORD, deviceOffset: Offset16) {
        self.value = value
        self.deviceOffset = deviceOffset
    }

    /// Reads a MathValueRecord from the provided pointer.
    /// - Parameter ptr: Pointer to the data from which to read the value record.
    static func read(_ ptr: UnsafePointer<UInt8>) -> MathValueRecord {
        MathValueRecord(value: readFWORD(ptr + 0),
                        deviceOffset: readOffset16(ptr + 2))
    }

    /// Evaluates a MathValueRecord.
    /// - Parameters:
    ///   - parentBase: Pointer to the beginning of the parent table.
    ///   - record: The MathValueRecord to evaluate.
    ///   - context: Contextual data for evaluation.
    /// - Returns: The evaluated value.
    static func eval(_ parentBase: UnsafePointer<UInt8>,
                     _ record: MathValueRecord,
                     _ context: ContextData) -> Int32
    {
        if record.deviceOffset == 0 {
            return Int32(record.value)
        }

        let deviceTable = DeviceTable(base: parentBase + Int(record.deviceOffset))
        let deltaValue = deviceTable.getDeltaValue(ppem: context.ppem,
                                                   unitsPerEm: context.unitsPerEm)
        return Int32(record.value) + deltaValue
    }
}
