import CoreFoundation
class MathKernInfoTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Offset to Coverage table, from the beginning of the MathKernInfo table.
    func mathKernCoverageOffset() -> Offset16 {
        readOffset16(base + 0)
    }

    /// Number of MathKernInfoRecords. Must be the same as the number of glyph
    /// IDs referenced in the Coverage table.
    func mathKernCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of MathKernInfoRecords, one for each covered glyph.
    func mathKernInfoRecords(_ index: Int) -> MathKernInfoRecord {
        MathKernInfoRecord.read(base + 4 + index * MathKernInfoRecord.byteSize)
    }

    // MARK: - optimization

    /// Returns the offset for given glyph index and corner
    private func mathKernOffset(_ index: Int, _ corner: MathKernCorner) -> Offset16 {
        let offset = 4 + index * MathKernInfoRecord.byteSize + corner.getOffset()
        return readOffset16(base + offset)
    }

    /// Returns the offset for given glyph id and corner
    private func getMathKernOffset(_ glyph: UInt16, _ corner: MathKernCorner) -> Offset16? {
        mathKernCoverageTable.getCoverageIndex(glyph).map {
            self.mathKernOffset($0, corner)
        }
    }

    // MARK: - Sub-tables

    private lazy var mathKernCoverageTable: CoverageTable = .init(base: base + Int(mathKernCoverageOffset()))

    func getMathKernTable(_ glyph: UInt16, _ corner: MathKernCorner) -> MathKernTable? {
        getMathKernOffset(glyph, corner).flatMap {
            ($0 != 0) ? MathKernTable(base: base + Int($0), context: self.context) : nil
        }
    }

    // MARK: - query functions

    func getMathKernInfoRecord(_ glyph: UInt16) -> MathKernInfoRecord? {
        mathKernCoverageTable.getCoverageIndex(glyph).map {
            self.mathKernInfoRecords($0)
        }
    }

    func getKernValue(_ glyph: UInt16,
                      _ corner: MathKernCorner,
                      _ height: Int32) -> Int32?
    {
        getMathKernTable(glyph, corner)?.getKernValue(height: height)
    }
}

class MathKernTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Number of heights at which the kern value changes.
    func heightCount() -> UInt16 {
        readUInt16(base + 0)
    }

    /// Array of correction heights, in design units, sorted from lowest to highest.
    func correctionHeight(_ index: Int) -> MathValueRecord {
        MathValueRecord.read(base + 2 + index * MathValueRecord.byteSize)
    }

    /// Array of kerning values for different height ranges.
    /// Negative values are used to move glyphs closer to each other.
    func kernValues(_ index: Int) -> MathValueRecord {
        let offset = 2 + Int(heightCount()) * MathValueRecord.byteSize + index * MathValueRecord.byteSize
        return MathValueRecord.read(base + offset)
    }

    // MARK: - query functions

    /// Returns the correction height at the given index in design units
    func getCorrectionHeight(_ index: Int) -> Int32 {
        MathValueRecord.eval(base, correctionHeight(index), context)
    }

    /// Returns the kern value at the given index in design units
    func getKernValue(index: Int) -> Int32 {
        MathValueRecord.eval(base, kernValues(index), context)
    }

    /// Returns the kern value for the given height in design units
    func getKernValue(height: Int32) -> Int32 {
        getKernValue(index: upper_bound(height: height))
    }

    func getKernEntries(_ startOffset: Int,
                        _ entriesCount: inout Int,
                        _ kernEntries: inout [MathKernEntryRecord]) -> Int
    {
        precondition(entriesCount >= 0)
        precondition(kernEntries.count >= entriesCount)

        let heightCount = Int(self.heightCount())
        let count = heightCount + 1
        let start = min(startOffset, count)
        let end = min(start + entriesCount, count)
        entriesCount = end - start

        for i in 0 ..< entriesCount {
            let j = start + i

            var maxHeight: Int32
            if j == heightCount {
                maxHeight = Int32.max
            } else {
                maxHeight = getCorrectionHeight(j)
            }

            let kernValue = getKernValue(index: j)
            kernEntries[i] = MathKernEntryRecord(maxCorrectionHeight: maxHeight,
                                                 kernValue: kernValue)
        }
        return entriesCount
    }

    func getKernEntryCount(startOffset: Int = 0) -> Int {
        precondition(startOffset >= 0)

        let count = Int(heightCount()) + 1
        let start = min(startOffset, count)
        return count - start
    }

    // MARK: - helper functions

    /// Returns the index of the first element greater than the given height.
    /// We adapt the implementation of `std::upper_bound()` from C++ STL.
    private func upper_bound(height: Int32) -> Int {
        var count = Int(heightCount())
        var i = 0

        // Assume:
        //      correctionHeight[-1] = -infty
        //      correctionHeight[heightCount()] = +infty
        // Loop invariant:
        //      0 <= i+count <= heightCount()
        //      correctionHeight[i-1] <= height < correctionHeight[i+count]
        // Termination:
        //      count is decreased in each iteration, and reaches 0 on loop end
        while count > 0 {
            let half = count / 2
            let correctionHeight = getCorrectionHeight(i + half)

            if !(height < correctionHeight) {
                i += half + 1
                count -= half + 1
            } else {
                count = half
            }
        }
        return i
    }
}

/// MathKernEntry in design units
struct MathKernEntryRecord {
    let maxCorrectionHeight: Int32
    let kernValue: Int32

    init(maxCorrectionHeight: Int32, kernValue: Int32) {
        self.maxCorrectionHeight = maxCorrectionHeight
        self.kernValue = kernValue
    }
}
