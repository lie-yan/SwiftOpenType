import CoreText

/// A wrapper of CTFont, extended with some contexts
public class OTFont {
    let font: CTFont
    /// pixels per em
    public let ppem: UInt32
    /// points per design unit
    public let sizePerUnit: CGFloat

    convenience init(_ font: CTFont) {
        self.init(font, 0)
    }

    init(_ font: CTFont, _ ppem: UInt32) {
        self.font = font
        self.ppem = ppem
        sizePerUnit = CTFontGetSize(font) / CGFloat(CTFontGetUnitsPerEm(font))
    }

    // MARK: - Auxilliary

    /// Returns a lambda that converts design units to points
    public func toPointsClosure() -> ((Int32) -> CGFloat) {
        { CGFloat($0) * self.sizePerUnit }
    }

    /// Returns a lambda that converts points to design units
    public func toDesignUnitsClosure() -> ((CGFloat) -> Int32) {
        { Int32($0 / self.sizePerUnit) }
    }

    // MARK: - tables

    public var mathTable: MathTableV2? { _mathTable }

    private lazy var _mathTable: MathTableV2? = {
        if let data = self.getMathTableData() {
            let table = MathTableV2(base: CFDataGetBytePtr(data), context: self.getContextData())
            if table.majorVersion() == 1 {
                return table
            }
        }
        return nil
    }()

    // MARK: - for internal use

    func getContextData() -> ContextData { ContextData(ppem: ppem, unitsPerEm: getUnitsPerEm()) }

    func getMathTableData() -> CFData? {
        CTFontCopyTable(font,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}


class ContextData {
    let ppem: UInt32
    let unitsPerEm: UInt32

    init(ppem: UInt32, unitsPerEm: UInt32) {
        self.ppem = ppem
        self.unitsPerEm = unitsPerEm
    }
}

/// int16 that describes a quantity in font design units.
public typealias FWORD = Int16
/// uint16 that describes a quantity in font design units.
public typealias UFWORD = UInt16
/// Short offset to a table, same as uint16, NULL offset = 0x0000
public typealias Offset16 = UInt16

/// Read UInt16 at ptr.
@inline(__always)
func readUInt16(_ ptr: UnsafePointer<UInt8>) -> UInt16 {
    // All OpenType fonts use Motorola-style byte ordering (Big Endian).
    ptr.withMemoryRebound(to: UInt16.self, capacity: 1) {
        $0.pointee.byteSwapped
    }
}

/// Read Int16 at ptr.
@inline(__always)
func readInt16(_ ptr: UnsafePointer<UInt8>) -> Int16 {
    // All OpenType fonts use Motorola-style byte ordering (Big Endian).
    ptr.withMemoryRebound(to: Int16.self, capacity: 1) {
        $0.pointee.byteSwapped
    }
}

@inline(__always)
func readFWORD(_ ptr: UnsafePointer<UInt8>) -> FWORD {
    readInt16(ptr)
}

@inline(__always)
func readUFWORD(_ ptr: UnsafePointer<UInt8>) -> UFWORD {
    readUInt16(ptr)
}

@inline(__always)
func readOffset16(_ ptr: UnsafePointer<UInt8>) -> Offset16 {
    readUInt16(ptr)
}
