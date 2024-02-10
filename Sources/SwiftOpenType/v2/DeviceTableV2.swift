import CoreFoundation

public class DeviceTableV2 {
    let base: UnsafePointer<UInt8>
    
    init(base: UnsafePointer<UInt8>) {
        self.base = base
    }
    
    /// Smallest size to correct, in ppem
    public func startSize() -> UInt16 {
        readUInt16(base + 0)
    }
    
    /// Largest size to correct, in ppem
    public func endSize() -> UInt16 {
        readUInt16(base + 2);
    }

    /// Format of deltaValue array data: 0x0001, 0x0002, or 0x0003
    public func deltaFormat() -> DeltaFormat {
        let deltaFormat = readUInt16(base + 4)
        assert(deltaFormat >= 0x0001 && deltaFormat <= 0x0003)
        return DeltaFormat(rawValue: deltaFormat)!
    }
    
    /// Array of compressed data
    /// The Device table includes an array of uint16 values (deltaValue[])
    /// that stores the adjustment delta values in a packed representation.
    /// The 2-, 4-, or 8-bit signed values are packed into uint16 values
    /// starting with the most significant bits first. For example, using
    /// a DeltaFormat of 2 (4-bit values), an array of values equal to {1, 2, 3, -1}
    /// would be represented by the DeltaValue 0x123F.
    public func deltaValue(_ index: Int) -> UInt16 {
        readUInt16(base + 6 + index * 2);
    }
    
    // MARK: - query
    
    /// Return delta value for given ppem.
    /// Return 0 if not available.
    public func getDeltaValue(ppem: UInt32, unitsPerEm: UInt32) -> Int32 {
        if ppem == 0 {
            return 0
        }
        
        let pixels = getDeltaPixels(ppem: ppem)
        
        if pixels == 0 {
            return 0
        }
        
        return Int32(Int64(pixels) * Int64(unitsPerEm) / Int64(ppem))
    }
    
    private func getDeltaPixels(ppem: UInt32) -> Int32 {
        let f = self.deltaFormat().rawValue
        // harfbuzz checks the range of f. We skip this step.
        
        let startSize = UInt32(self.startSize())
        let endSize = UInt32(self.endSize())
        
        if ppem < startSize || ppem > endSize {
            return 0
        }
        
        let s = Int(ppem - startSize)
        
        // Implementation note:
        //  For the sake of performance, we avoid multiplications and
        //  divisions, and use bit manipulations instead.
        
        let bitsPerItem = 1 << f
        // itemsPerWord = 16 / bitsPerItem
        let itemsPerWord = 1 << (4 - f)
        // wordIndex = s / itemsPerWord
        let wordIndex = s >> (4 - f)
        let word = self.deltaValue(wordIndex)
        
        // itemIndex = s % itemsPerWord
        let itemIndex = s & (itemsPerWord - 1)
        // x = word >> (16 - bitsPerItem - itemIndex * bitsPerItem)
        var x = Int(word >> (16 - ((itemIndex + 1) << f)))
        // E.g. for f = 2,
        //  mask = 0b1000
        //  ((1 << bitsPerItem) - 1) = 0b1111
        let mask = 1 << (bitsPerItem - 1)
        x = x & ((1 << bitsPerItem) - 1)
        return Int32((x^mask) - mask)
    }
}
