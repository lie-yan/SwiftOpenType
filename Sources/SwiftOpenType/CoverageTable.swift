import CoreText

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
}

public class CoverageTable {
    let data: CFData
    let tableOffset: Offset16 /// offset of coverage table - from the beginning of data

    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }

    public func coverageFormat() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 0)
    }

    /// Number of glyphs in the glyph array
    /// Coverage Format 1
    public func glyphCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }

    /// Array of glyph IDs — in numerical order
    /// Coverage Format 1
    public func glyphArray(_ index: Int) -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 4 + index * 2)
    }

    /// Number of RangeRecords
    /// Coverage Format 2
    public func rangeCount() -> UInt16 {
        data.readUInt16(parentOffset: tableOffset, offset: 2)
    }

    /// Array of glyph ranges — ordered by startGlyphID.
    /// Coverage Format 2
    public func rangeRecords(_ index: Int) -> RangeRecord {
        data.readRangeRecord(parentOffset: tableOffset, offset: 4 + index * RangeRecord.byteSize)
    }

    public func getCoverageIndex(_ glyphID: UInt16) -> Int? {
        let coverageFormat = self.coverageFormat()
        if (coverageFormat == 1) {
            return binarySearch_1(target: glyphID)
        }
        else if (coverageFormat == 2) {
            return binarySearch_2(target: glyphID)
        }

        return nil
    }

    /// binary search for Coverage Format 1
    private func binarySearch_1(target: UInt16) -> Int? {
        var left = 0
        var right = Int(glyphCount()) - 1

        while (left <= right) {
            let mid = left + (right - left) / 2
            let value = glyphArray(mid)

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
            let value = rangeRecords(mid)

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
