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
    
    private func mathKernOffset(index: Int, corner: MathKernCorner) -> Offset16 {
        let offset = 4 + index * MathKernInfoRecord.byteSize + corner.getOffset()
        return readOffset16(base + offset)
    }
    
    private func getMathKernOffset(glyph: UInt16, corner: MathKernCorner) -> Offset16? {
        let coverageTable = self.coverageTable()
        if let coverageIndex = coverageTable.getCoverageIndex(glyph: glyph) {
            return mathKernOffset(index: coverageIndex, corner: corner)
        }
        return nil
    }
    
    // MARK: - Sub-tables
    
    public func coverageTable() -> CoverageTableV2 {
        CoverageTableV2(base: base + Int(mathKernCoverageOffset()))
    }
    
    // MARK: - query functions

    public func getMathKernInfoRecord(glyph: UInt16) -> MathKernInfoRecord? {
        let coverageTable = self.coverageTable()
        if let coverageIndex = coverageTable.getCoverageIndex(glyph: glyph) {
            return self.mathKernInfoRecords(index: coverageIndex)
        }
        return nil
    }
    
    public func getKernValue(glyph: UInt16, corner: MathKernCorner, height: Int32) -> Int32? {
        if let mathKernOffset = getMathKernOffset(glyph: glyph, corner: corner) {
            let mathKernTable = MathKernTableV2(base: base + Int(mathKernOffset), context: context)
            return mathKernTable.getKernValue(height: height)
        }
        return nil
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
        let mathValueRecord = self.correctionHeight(index: index)
        return MathValueRecord.eval(parentBase: base,
                                    mathValueRecord: mathValueRecord,
                                    context: context)
    }
    
    /// Return the kern value at the given index in design units
    public func getKernValue(index: Int) -> Int32 {
        let mathValueRecord = self.kernValues(index: index)
        return MathValueRecord.eval(parentBase: base,
                                    mathValueRecord: mathValueRecord,
                                    context: context)
    }
    
    /// Return the kern value for the given height in design units
    public func getKernValue(height: Int32) -> Int32 {
        let index = upper_bound(height: height)
        return self.getKernValue(index: index)
    }
    
    // MARK: - helper functions
    
    /// Return the index of the first element greater than the given height.
    /// We adapt the implementation of `std::upper_bound()` from C++ STL.
    private func upper_bound(height: Int32) -> Int {
        var count = Int(self.heightCount())
        var i = 0
        
        // Assume:
        //      correctionHeight[-1] = -infty
        //      correctionHeight[heightCount()] = +infty
        // Loop invariant:
        //      0 <= i+count <= heightCount()
        //      correctionHeight[i-1] <= height < correctionHeight[i+count]
        // Termination:
        //      count is decreased in each iteration, and reaches 0 on loop end
        while (count > 0) {
            let half = count / 2
            let correctionHeight = getCorrectionHeight(index: i + half)
            
            if !(height < correctionHeight) {
                i += half + 1
                count -= half + 1
            }
            else {
                count = half
            }
        }
        return i
    }
}
