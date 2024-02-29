import CoreFoundation


public class MathTableV2 {
    let base: UnsafePointer<UInt8>
    let context: ContextData
    
    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }
    
    // MARK: - header fields
    
    /// Major version of the MATH table, = 1.
    public func majorVersion() -> UInt16 {
        readUInt16(base + 0)
    }
    
    /// Minor version of the MATH table, = 0.
    public func minorVersion() -> UInt16 {
        readUInt16(base + 2)
    }
    
    /// Offset to MathConstants table - from the beginning of MATH table.
    public func mathConstantsOffset() -> Offset16 {
        readOffset16(base + 4)
    }
    
    /// Offset to MathGlyphInfo table - from the beginning of MATH table.
    public func mathGlyphInfoOffset() -> Offset16 {
        readOffset16(base + 6)
    }
    
    /// Offset to MathVariants table - from the beginning of MATH table.
    public func mathVariantsOffset() -> Offset16 {
        readOffset16(base + 8)
    }
    
    // MARK: - Sub-tables
    
    public var mathConstantsTable: MathConstantsTableV2? {
        self._mathConstantsTable
    }
    
    public var mathGlyphInfoTable: MathGlyphInfoTableV2? {
        self._mathGlyphInfoTable
    }
    
    public var mathVariantsTable: MathVariantsTableV2? {
        self._mathVariantsTable
    }
    
    // MARK: - lazy variables
    
    private lazy var _mathConstantsTable: MathConstantsTableV2? = {
        let offset = self.mathConstantsOffset()
        if offset != 0 {
            return MathConstantsTableV2(base: self.base + Int(offset),
                                        context: self.context)
        }
        else {
            return nil
        }
    }()
    
    private lazy var _mathGlyphInfoTable: MathGlyphInfoTableV2? = {
        let offset = self.mathGlyphInfoOffset()
        if offset != 0 {
            return MathGlyphInfoTableV2(base: self.base + Int(offset),
                                        context: self.context)
        }
        else {
            return nil
        }
    }()
    
    private lazy var _mathVariantsTable: MathVariantsTableV2? = {
        let offset = self.mathVariantsOffset()
        if offset != 0 {
            return MathVariantsTableV2(base: self.base + Int(offset))
        }
        else {
            return nil
        }
    }()
}

/// The Device and VariationIndex tables contain a DeltaFormat field that
/// identifies the format of data contained. Format values 0x0001 to 0x0003
/// are used for Device tables, and indicate the format of delta adjustment
/// values contained directly within the device table: signed 2-, 4,- or 8-bit
/// values. A format value of 0x8000 is used for the VariationIndex table, and
/// indicates that a delta-set index is used to reference delta data in an
/// ItemVariationStore table.
public enum DeltaFormat : UInt16 {
    /// Signed 2-bit value, 8 values per uint16
    case LOCAL_2_BIT_DELTAS = 0x0001
    
    /// Signed 4-bit value, 4 values per uint16
    case LOCAL_4_BIT_DELTAS = 0x0002
    
    /// Signed 8-bit value, 2 values per uint16
    case LOCAL_8_BIT_DELTAS = 0x0003
    
    /// VariationIndex table, contains a delta-set index pair.
    case VARIATION_INDEX = 0x8000
    
    /// For future use — set to 0
    case Reserved = 0x7FFC
    
    public func getBitsPerItem() -> Int? {
        if rawValue <= DeltaFormat.LOCAL_8_BIT_DELTAS.rawValue {
            return 1 << rawValue
        }
        else {
            return nil
        }
    }
}

public struct MathValueRecord {
    static let byteSize = 4

    /// The X or Y value in design units
    public let value: FWORD
    /// Offset to the device table — from the beginning of parent table.
    /// May be NULL. Suggested format for device table is 1.
    public let deviceOffset: Offset16

    init() {
        self.init(value: 0, deviceOffset: 0)
    }

    init(value: FWORD, deviceOffset: Offset16) {
        self.value = value
        self.deviceOffset = deviceOffset
    }
    
    // TODO: remove this
    static func read(data: CFData, offset: Int) -> MathValueRecord {
        let value = data.readFWORD(offset)
        let deviceOffset = data.readOffset16(offset + 2)
        return MathValueRecord(value: value, deviceOffset: deviceOffset)
    }
    
    // TODO: remove this
    static func read(data: CFData, parentOffset: Offset16, offset: Int) -> MathValueRecord {
        read(data: data, offset: Int(parentOffset) + offset)
    }
    
    static func read(ptr: UnsafePointer<UInt8>) -> MathValueRecord {
        let value = readFWORD(ptr + 0)
        let deviceOffset = readOffset16(ptr + 2)
        return MathValueRecord(value: value, deviceOffset: deviceOffset)
    }
    
    static func eval(parentBase: UnsafePointer<UInt8>,
                     mathValueRecord: MathValueRecord,
                     context: ContextData) -> Int32 {
        if mathValueRecord.deviceOffset == 0 {
            return Int32(mathValueRecord.value)
        }
        
        let deviceTable = DeviceTableV2(base: parentBase + Int(mathValueRecord.deviceOffset))
        let deltaValue = deviceTable.getDeltaValue(ppem: context.ppem, unitsPerEm: context.unitsPerEm)
        return Int32(mathValueRecord.value) + deltaValue
    }
}
