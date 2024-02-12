import CoreFoundation

public class MathGlyphInfoTableV2 {
    let base: UnsafePointer<UInt8>
    let context: ContextData
    
    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }
    
    // MARK: - Header fields
    
    /// Offset to MathItalicsCorrectionInfo table, from the beginning of the MathGlyphInfo table.
    public func mathItalicsCorrectionInfoOffset() -> Offset16 {
        readOffset16(base + 0)
    }
    
    /// Offset to MathTopAccentAttachment table, from the beginning of the MathGlyphInfo table.
    public func mathTopAccentAttachmentOffset() -> Offset16 {
        readOffset16(base + 2)
    }
    
    /// Offset to ExtendedShapes coverage table, from the beginning of the MathGlyphInfo table.
    /// When the glyph to the left or right of a box is an extended shape variant, the (ink) box
    /// should be used for vertical positioning purposes, not the default position defined by
    /// values in MathConstants table. May be NULL.
    public func extendedShapeCoverageOffset() -> Offset16 {
        readOffset16(base + 4)
    }
    
    /// Offset to MathKernInfo table, from the beginning of the MathGlyphInfo table.
    public func mathKernInfoOffset() -> Offset16 {
        readOffset16(base + 6)
    }
    
    // MARK: - Sub-tables
    public var mathItalicsCorrectionInfoTable: MathItalicsCorrectionInfoTableV2? {
        self._mathItalicsCorrectionInfoTable
    }
    
    public var mathTopAccentAttachmentTable: MathTopAccentAttachmentTableV2? {
        self._mathTopAccentAttachmentTable
    }
    
    // MARK: - lazy variables
    private lazy var _mathItalicsCorrectionInfoTable: MathItalicsCorrectionInfoTableV2? = {
        let offset = mathItalicsCorrectionInfoOffset()
        if offset != 0 {
            return MathItalicsCorrectionInfoTableV2(base: self.base + Int(offset),
                                                    context: self.context)
        }
        else {
            return nil
        }
    }()
    
    private lazy var _mathTopAccentAttachmentTable: MathTopAccentAttachmentTableV2? = {
        let offset = mathTopAccentAttachmentOffset()
        if offset != 0 {
            return MathTopAccentAttachmentTableV2(base: self.base + Int(offset),
                                                  context: self.context)
        }
        else {
            return nil
        }
    }()
}
