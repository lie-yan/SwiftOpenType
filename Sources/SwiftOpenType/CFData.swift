import CoreFoundation

/// int16 that describes a quantity in font design units.
public typealias FWORD = Int16
/// uint16 that describes a quantity in font design units.
public typealias UFWORD = UInt16
/// Short offset to a table, same as uint16, NULL offset = 0x0000
public typealias Offset16 = UInt16

/// Extend CFData for internal use.
///
/// All OpenType fonts use Motorola-style byte ordering (Big Endian).
internal extension CFData {
    /// Read UInt16 at the given (byte) offset
    func readUInt16(_ offset: Int) -> UInt16 {
        let ptr = CFDataGetBytePtr(self)!
        return (ptr+offset).withMemoryRebound(to: UInt16.self, capacity: 1) {
            $0.pointee.byteSwapped
        }
    }
    
    /// Read Int16 at the given (byte) offset
    func readInt16(_ offset: Int) -> Int16 {
        let ptr = CFDataGetBytePtr(self)!
        return (ptr+offset).withMemoryRebound(to: Int16.self, capacity: 1) {
            $0.pointee.byteSwapped
        }
    }
    
    /// Read Offset16 at the given (byte) offset
    func readOffset16(_ offset: Int) -> Offset16 {
        readUInt16(offset)
    }
    
    /// Read FWORD at the given (byte) offset
    func readFWORD(_ offset: Int) -> FWORD {
        readInt16(offset)
    }
    
    /// Read UFWORD at the given (byte) offset
    func readUFWORD(_ offset: Int) -> UFWORD {
        readUInt16(offset)
    }
                    
    /// Read Int16 at the given (byte) offset
    func readInt16(parentOffset: Offset16, offset: Int) -> Int16 {
        readInt16(Int(parentOffset) + offset)
    }
    
    /// Read UInt16 at the given (byte) offset
    func readUInt16(parentOffset: Offset16, offset: Int) -> UInt16 {
        readUInt16(Int(parentOffset) + offset)
    }
    
    /// Read Offset16 at the given (byte) offset
    func readOffset16(parentOffset: Offset16, offset: Int) -> Offset16 {
        readOffset16(Int(parentOffset) + offset)
    }
    
    /// Read FWORD at the given (byte) offset
    func readFWORD(parentOffset: Offset16, offset: Int) -> FWORD {
        readFWORD(Int(parentOffset) + offset)
    }
    
    /// Read UFWORD at the given (byte) offset
    func readUFWORD(parentOffset: Offset16, offset: Int) -> UFWORD {
        readUFWORD(Int(parentOffset) + offset)
    }
                    
    /// Read adjustment from device table
    func readDeviceDelta(parentOffset: Offset16, deviceOffset: Offset16) -> Int16 {
        // TODO: add device delta
        if (deviceOffset != 0) {
            print("device table present at offset \(parentOffset): \(deviceOffset)")
            let deviceTable = parentOffset + deviceOffset
            let startSize = readUInt16(parentOffset: deviceTable, offset: 0)
            let endSize = readUInt16(parentOffset: deviceTable, offset: 2)
            let deltaFormat = readUInt16(parentOffset: deviceTable, offset: 4)
            let first16 = readUInt16(parentOffset: deviceTable, offset: 6)
            print(" sizes: \(startSize) to \(endSize); format: \(deltaFormat); first word: \(first16)")
        }
        return 0
    }
    
    /// Evaluate the given MathValueRecord, and return the result value of design units.
    func evalMathValueRecord(parentOffset: Offset16, mathValueRecord: MathValueRecord) -> Int32 {
        let deltaValue = readDeviceDelta(parentOffset: parentOffset, deviceOffset: mathValueRecord.deviceOffset)
        return Int32(mathValueRecord.value) + Int32(deltaValue)
    }
}
