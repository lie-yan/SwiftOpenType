import CoreFoundation

public class CoverageTable {
    let data: CFData
    let tableOffset: Offset16 /// offset of coverage table - from the beginning of data

    init(data: CFData, tableOffset: Offset16) {
        precondition(tableOffset != 0)
        
        self.data = data
        self.tableOffset = tableOffset
    }

    // MARK: - Table fields
    
    public func coverageFormat() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 0)
    }

    /// Number of glyphs in the glyph array.
    /// For Coverage Format 1
    public func glyphCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }

    /// Array of glyph IDs — in numerical order.
    /// For Coverage Format 1
    public func glyphArray(index: Int) -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 4 + index * 2)
    }

    /// Number of RangeRecords.
    /// For Coverage Format 2
    public func rangeCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }

    /// Array of glyph ranges — ordered by startGlyphID.
    /// For Coverage Format 2
    public func rangeRecords(index: Int) -> RangeRecord {
        let offset = Int(tableOffset) + 4 + index * RangeRecord.byteSize
        return RangeRecord.read(data: data, offset: offset)
    }

    // MARK: - Query functions
    
    /// Given glyph id, return the coverage index for it.
    /// If not found, return nil.
    public func getCoverageIndex(glyphID: UInt16) -> Int? {
        let coverageFormat = self.coverageFormat()
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
