import CoreFoundation

public class MathKernInfoTableV2 {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Offset to Coverage table, from the beginning of the MathKernInfo table.
    public func mathKernCoverageOffset() -> Offset16 {
        readOffset16(base + 0)
    }

    /// Number of MathKernInfoRecords. Must be the same as the number of glyph
    /// IDs referenced in the Coverage table.
    public func mathKernCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of MathKernInfoRecords, one for each covered glyph.
    public func mathKernInfoRecords(index: Int) -> MathKernInfoRecord {
        MathKernInfoRecord.read(ptr: base + 4 + index * MathKernInfoRecord.byteSize)
    }

    // MARK: - optimization

    /// Return the offset for given glyph index and corner
    private func mathKernOffset(index: Int, corner: MathKernCorner) -> Offset16 {
        let offset = 4 + index * MathKernInfoRecord.byteSize + corner.getOffset()
        return readOffset16(base + offset)
    }

    /// Return the offset for given glyph id and corner
    private func getMathKernOffset(glyph: UInt16, corner: MathKernCorner) -> Offset16? {
        let coverageTable = self.coverageTable()
        if let coverageIndex = coverageTable.getCoverageIndex(glyph) {
            return mathKernOffset(index: coverageIndex, corner: corner)
        }
        return nil
    }

    // MARK: - Sub-tables

    public func coverageTable() -> CoverageTableV2 {
        CoverageTableV2(base: base + Int(mathKernCoverageOffset()))
    }

    public func getMathKernTable(glyph: UInt16, corner: MathKernCorner) -> MathKernTableV2? {
        if let offset = getMathKernOffset(glyph: glyph, corner: corner) {
            return MathKernTableV2(base: base + Int(offset), context: context)
        }
        return nil
    }

    // MARK: - query functions

    public func getMathKernInfoRecord(glyph: UInt16) -> MathKernInfoRecord? {
        let coverageTable = self.coverageTable()
        if let coverageIndex = coverageTable.getCoverageIndex(glyph) {
            return mathKernInfoRecords(index: coverageIndex)
        }
        return nil
    }

    public func getKernValue(_ glyph: UInt16,
                             _ corner: MathKernCorner,
                             _ height: Int32) -> Int32? {
        getMathKernTable(glyph: glyph, corner: corner)?.getKernValue(height: height)
    }
}

public class MathKernTableV2 {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Number of heights at which the kern value changes.
    public func heightCount() -> UInt16 {
        readUInt16(base + 0)
    }

    /// Array of correction heights, in design units, sorted from lowest to highest.
    public func correctionHeight(index: Int) -> MathValueRecord {
        MathValueRecord.read(ptr: base + 2 + index * MathValueRecord.byteSize)
    }

    /// Array of kerning values for different height ranges.
    /// Negative values are used to move glyphs closer to each other.
    public func kernValues(index: Int) -> MathValueRecord {
        let offset = 2 + Int(heightCount()) * MathValueRecord.byteSize + index * MathValueRecord.byteSize
        return MathValueRecord.read(ptr: base + offset)
    }

    // MARK: - query functions

    /// Return the correction height at the given index in design units
    public func getCorrectionHeight(index: Int) -> Int32 {
        MathValueRecord.eval(base,
                             self.correctionHeight(index: index),
                             context)
    }

    /// Return the kern value at the given index in design units
    public func getKernValue(index: Int) -> Int32 {
        MathValueRecord.eval(base,
                             self.kernValues(index: index),
                             context)
    }

    /// Return the kern value for the given height in design units
    public func getKernValue(height: Int32) -> Int32 {
        self.getKernValue(index: self.upper_bound(height: height))
    }

    public func getKernEntries(startOffset: Int,
                               entriesCount: inout Int,
                               kernEntries: inout [KernEntryDU]) -> Int
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
                maxHeight = getCorrectionHeight(index: j)
            }

            let kernValue = getKernValue(index: j)
            kernEntries[i] = KernEntryDU(maxCorrectionHeight: maxHeight,
                                         kernValue: kernValue)
        }
        return entriesCount
    }

    public func getKernEntryCount(startOffset: Int) -> Int {
        precondition(startOffset >= 0)

        let count = Int(self.heightCount()) + 1
        let start = min(startOffset, count)
        return count - start
    }

    // MARK: - helper functions

    /// Return the index of the first element greater than the given height.
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
            let correctionHeight = getCorrectionHeight(index: i + half)

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

/// KernEntry in design units
public struct KernEntryDU {
    public let maxCorrectionHeight: Int32
    public let kernValue: Int32

    init(maxCorrectionHeight: Int32, kernValue: Int32) {
        self.maxCorrectionHeight = maxCorrectionHeight
        self.kernValue = kernValue
    }
}
