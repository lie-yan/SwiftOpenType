import CoreText

public class OTFont {
    let font: CTFont
    let ppem: UInt /// pixels-per-em
    
    convenience init(font: CTFont) {
        self.init(font: font, ppem: 0)
    }
    
    init(font: CTFont, ppem: UInt) {
        self.font = font
        self.ppem = ppem
    }
    
    public var mathTable: MathTableV2? {
        if let data = self.getMathTableData() {
            let table = MathTableV2(base: CFDataGetBytePtr(data)!)
            if table.majorVersion() == 1 {
                return table
            }
        }
        return nil
    }

    public func sizePerUnit() -> CGFloat {
        CTFontGetSize(font) / CGFloat(CTFontGetUnitsPerEm(font))
    }
    
    private func getMathTableData() -> CFData? {
        CTFontCopyTable(font,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}

/// int16 that describes a quantity in font design units.
public typealias FWORD = Int16
/// uint16 that describes a quantity in font design units.
public typealias UFWORD = UInt16
/// Short offset to a table, same as uint16, NULL offset = 0x0000
public typealias Offset16 = UInt16

/// Read UInt16 at ptr.
func readUInt16(_ ptr: UnsafePointer<UInt8>) -> UInt16 {
    // All OpenType fonts use Motorola-style byte ordering (Big Endian).
    ptr.withMemoryRebound(to: UInt16.self, capacity: 1) {
        $0.pointee.byteSwapped
    }
}

/// Read Int16 at ptr.
func readInt16(_ ptr: UnsafePointer<UInt8>) -> Int16 {
    // All OpenType fonts use Motorola-style byte ordering (Big Endian).
    ptr.withMemoryRebound(to: Int16.self, capacity: 1) {
        $0.pointee.byteSwapped
    }
}

func readFWORD(_ ptr: UnsafePointer<UInt8>) -> FWORD {
    readInt16(ptr)
}

func readUFWORD(_ ptr: UnsafePointer<UInt8>) -> UFWORD {
    readUInt16(ptr)
}

func readOffset16(_ ptr: UnsafePointer<UInt8>) -> Offset16 {
    readUInt16(ptr)
}
