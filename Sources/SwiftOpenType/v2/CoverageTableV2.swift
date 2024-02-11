import CoreFoundation

public class CoverageTableV2 {
    let base: UnsafePointer<UInt8>
    
    init(base: UnsafePointer<UInt8>) {
        self.base = base
        self.coverageFormat = readUInt16(base + 0)
    }

    // MARK: - Table fields
    
    /// Format identifier
    public let coverageFormat: UInt16

    /// Number of glyphs in the glyph array.
    /// For Coverage Format 1
    public func glyphCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of glyph IDs — in numerical order.
    /// For Coverage Format 1
    public func glyphArray(index: Int) -> UInt16 {
        readUInt16(base + 4 + index * 2)
    }

    /// Number of RangeRecords.
    /// For Coverage Format 2
    public func rangeCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of glyph ranges — ordered by startGlyphID.
    /// For Coverage Format 2
    public func rangeRecords(index: Int) -> RangeRecord {
        RangeRecord.read(ptr: base + 4 + index * RangeRecord.byteSize)
    }

    // MARK: - Query functions
    
    /// Given glyph id, return the coverage index for it.
    /// If not found, return nil.
    public func getCoverageIndex(glyphID: UInt16) -> Int? {
        let coverageFormat = self.coverageFormat
        if (coverageFormat == 1) {
            return binarySearch_1(target: glyphID)
        }
        else if (coverageFormat == 2) {
            return binarySearch_2(target: glyphID)
        }

        return nil
    }
    
    // MARK: - helper functions

    /// binary search for Coverage Format 1
    private func binarySearch_1(target: UInt16) -> Int? {
        var left = 0
        var right = Int(glyphCount()) - 1

        while (left <= right) {
            let mid = left + (right - left) / 2
            let value = glyphArray(index: mid)

            if (value == target) {
                return mid
            }
            else if (value < target) {
                left = mid + 1
            }
            else {
                right = mid - 1
            }
        }
        return nil
    }

    /// binary search for Coverage Format 2
    private func binarySearch_2(target: UInt16) -> Int? {
        var left = 0
        var right = Int(rangeCount()) - 1

        while (left <= right) {
            let mid = left + (right - left) / 2
            let value = rangeRecords(index: mid)

            if (target >= value.startGlyphID && target <= value.endGlyphID) {
                return Int(value.startCoverageIndex + (target - value.startGlyphID))
            }
            else if (value.endGlyphID < target) {
                left = mid + 1
            }
            else {
                right = mid - 1
            }
        }
        return nil
    }
}

public struct RangeRecord {
    static let byteSize = 6
    
    public let startGlyphID: UInt16 /// First glyph ID in the range
    public let endGlyphID: UInt16   /// Last glyph ID in the range
    public let startCoverageIndex: UInt16 /// Coverage Index of first glyph ID in range

    init() {
        self.init(startGlyphID: 0, endGlyphID: 0, startCoverageIndex: 0)
    }

    init(startGlyphID: UInt16, endGlyphID: UInt16, startCoverageIndex: UInt16) {
        self.startGlyphID = startGlyphID
        self.endGlyphID = endGlyphID
        self.startCoverageIndex = startCoverageIndex
    }
    
    // deprecated
    static func read(data: CFData, offset: Int) -> RangeRecord {
        let startGlyphID = data.readUInt16(offset)
        let endGlyphID = data.readUInt16(offset + 2)
        let startCoverageIndex = data.readUInt16(offset + 4)
        return RangeRecord(startGlyphID: startGlyphID,
                           endGlyphID: endGlyphID,
                           startCoverageIndex: startCoverageIndex)
    }
    
    static func read(ptr: UnsafePointer<UInt8>) -> RangeRecord {
        let startGlyphID = readUInt16(ptr + 0)
        let endGlyphID = readUInt16(ptr + 2)
        let startCoverageIndex = readUInt16(ptr + 4)

        return RangeRecord(startGlyphID: startGlyphID,
                           endGlyphID: endGlyphID,
                           startCoverageIndex: startCoverageIndex)
    }
}
