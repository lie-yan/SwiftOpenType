import CoreFoundation

public class DeviceTable {
    let data: CFData
    let tableOffset: Offset16 /// offset of device table - from the beginning of data
    
    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }
    
    /// Smallest size to correct, in ppem
    public func startSize() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 0)
    }
    
    /// Largest size to correct, in ppem
    public func endSize() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2);
    }
    
    /// Format of deltaValue array data: 0x0001, 0x0002, or 0x0003
    public func deltaFormat() -> DeltaFormat {
        let deltaFormat = data.readUInt16(parentOffset: tableOffset, offset: 4)
        assert(deltaFormat >= 0x0001 && deltaFormat <= 0x0003)
        return DeltaFormat(rawValue: deltaFormat)!
    }
    
    /// Array of compressed data
    public func deltaValue(_ index: Int) -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 6 + index * 2);
    }
    
    /// Retrieve delta value for given ppem
    public func getDeltaValue(ppem: UInt16) -> Int32? {
        let deltaFormat = self.deltaFormat()
        let startSize = self.startSize()
        let endSize = self.endSize()
        
        if ppem < startSize || ppem > endSize {
            return nil
        }
        
        let bitsPerItem = deltaFormat.getBitsPerItem()!
        let index = Int(ppem - startSize)
        let itemsPerWord = 16 / bitsPerItem
                        
        return DeviceTable.decodeDeltaValue(word: self.deltaValue(index / itemsPerWord),
                                            index: index % itemsPerWord,
                                            bitsPerItem: bitsPerItem)
    }
    
    /// index: item index from highest bit
    static func decodeDeltaValue(word: UInt16, index: Int, bitsPerItem: Int) -> Int32 {
        var x = Int32(word >> (16 - bitsPerItem - index * bitsPerItem))
        let m = Int32(1) << (bitsPerItem - 1)
        x = x & ((Int32(1) << bitsPerItem) - 1)
        return (x^m) - m
    }
}
