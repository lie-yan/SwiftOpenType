import CoreFoundation


/**
 * A Coverage table identifies glyphs by glyph indices (glyph IDs).
 *
 * Reference: [Coverage Table](https://learn.microsoft.com/en-us/typography/opentype/spec/chapter2#coverage-table)
 */
class CoverageTable {
    let base: UnsafePointer<UInt8>

    init(base: UnsafePointer<UInt8>) {
        self.base = base
    }

    // MARK: - Table fields
    // The method names in this section follow the OpenType spec.

    /// Format identifier
    func coverageFormat() -> UInt16 {
        readUInt16(base + 0)
    }

    /// Number of glyphs in the glyph array.
    /// For Coverage Format 1
    func glyphCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of glyph IDs — in numerical order.
    /// For Coverage Format 1
    func glyphArray(_ index: Int) -> UInt16 {
        readUInt16(base + 4 + index * 2)
    }

    /// Number of RangeRecords.
    /// For Coverage Format 2
    func rangeCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of glyph ranges — ordered by startGlyphID.
    /// For Coverage Format 2
    func rangeRecords(_ index: Int) -> RangeRecord {
        RangeRecord.read(base + 4 + index * RangeRecord.byteSize)
    }

    // MARK: - Query functions

    /// Given glyph id, return the coverage index for it.
    /// If not found, return nil.
    func getCoverageIndex(_ glyph: UInt16) -> Int? {
        let f = coverageFormat()
        if f == 1 {
            return binarySearch_1(glyph)
        } else if f == 2 {
            return binarySearch_2(glyph)
        }

        return nil
    }

    // MARK: - helper functions

    /// binary search for Coverage Format 1
    private func binarySearch_1(_ target: UInt16) -> Int? {
        var left = 0
        var right = Int(glyphCount()) - 1

        while left <= right {
            let mid = left + (right - left) / 2
            let value = glyphArray(mid)

            if value == target {
                return mid
            } else if value < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        return nil
    }

    /// binary search for Coverage Format 2
    private func binarySearch_2(_ target: UInt16) -> Int? {
        var left = 0
        var right = Int(rangeCount()) - 1

        while left <= right {
            let mid = left + (right - left) / 2
            let value = rangeRecords(mid)

            if target >= value.startGlyphID, target <= value.endGlyphID {
                return Int(value.startCoverageIndex + (target - value.startGlyphID))
            } else if value.endGlyphID < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        return nil
    }
}

struct RangeRecord {
    static let byteSize = 6

    let startGlyphID: UInt16 /// First glyph ID in the range
    let endGlyphID: UInt16 /// Last glyph ID in the range
    let startCoverageIndex: UInt16 /// Coverage Index of first glyph ID in range

    init() {
        self.init(startGlyphID: 0, endGlyphID: 0, startCoverageIndex: 0)
    }

    init(startGlyphID: UInt16, endGlyphID: UInt16, startCoverageIndex: UInt16) {
        self.startGlyphID = startGlyphID
        self.endGlyphID = endGlyphID
        self.startCoverageIndex = startCoverageIndex
    }

    static func read(_ ptr: UnsafePointer<UInt8>) -> RangeRecord {
        RangeRecord(startGlyphID: readUInt16(ptr + 0),
                    endGlyphID: readUInt16(ptr + 2),
                    startCoverageIndex: readUInt16(ptr + 4))
    }
}
