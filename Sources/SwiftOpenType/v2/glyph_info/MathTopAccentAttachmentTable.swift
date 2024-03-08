import CoreFoundation

public class MathTopAccentAttachmentTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    // MARK: - table fields

    /// Offset to Coverage table, from the beginning of the MathTopAccentAttachment table.
    public func topAccentCoverageOffset() -> Offset16 {
        readOffset16(base + 0)
    }

    /// Number of top accent attachment point values. Must be the same as the number of
    /// glyph IDs referenced in the Coverage table.
    public func topAccentAttachmentCount() -> UInt16 {
        readUInt16(base + 2)
    }

    /// Array of MathValueRecords defining top accent attachment points for each covered glyph.
    public func topAccentAttachment(_ index: Int) -> MathValueRecord {
        MathValueRecord.read(base + 4 + index * MathValueRecord.byteSize)
    }

    // MARK: - Query function

    /// Return top accent attachment for glyphID in design units
    public func getTopAccentAttachment(_ glyph: UInt16) -> Int32? {
        coverageTable.getCoverageIndex(glyph).map {
            let record = self.topAccentAttachment($0)
            return MathValueRecord.eval(base, record, context)
        }
    }

    // MARK: - helper

    public var coverageTable: CoverageTableV2 {
        _coverageTable
    }

    private lazy var _coverageTable: CoverageTableV2 = .init(base: self.base + Int(self.topAccentCoverageOffset()))
}
