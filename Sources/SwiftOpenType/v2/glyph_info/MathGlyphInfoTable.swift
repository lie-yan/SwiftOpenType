import CoreFoundation

public class MathGlyphInfoTable {
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

    public var mathItalicsCorrectionInfoTable: MathItalicsCorrectionInfoTable? {
        _mathItalicsCorrectionInfoTable
    }

    public var mathTopAccentAttachmentTable: MathTopAccentAttachmentTable? {
        _mathTopAccentAttachmentTable
    }

    public var extendedShapeCoverageTable: CoverageTableV2? {
        _extendedShapeCoverageTable
    }

    public var mathKernInfoTable: MathKernInfoTable? {
        _mathKernInfoTable
    }

    // MARK: - lazy variables

    private lazy var _mathItalicsCorrectionInfoTable: MathItalicsCorrectionInfoTable? = {
        let offset = mathItalicsCorrectionInfoOffset()
        if offset != 0 {
            return MathItalicsCorrectionInfoTable(base: self.base + Int(offset),
                                                  context: self.context)
        } else {
            return nil
        }
    }()

    private lazy var _mathTopAccentAttachmentTable: MathTopAccentAttachmentTable? = {
        let offset = mathTopAccentAttachmentOffset()
        if offset != 0 {
            return MathTopAccentAttachmentTable(base: self.base + Int(offset),
                                                context: self.context)
        } else {
            return nil
        }
    }()

    private lazy var _extendedShapeCoverageTable: CoverageTableV2? = {
        let offset = extendedShapeCoverageOffset()
        if offset != 0 {
            return CoverageTableV2(base: self.base + Int(offset))
        } else {
            return nil
        }
    }()

    private lazy var _mathKernInfoTable: MathKernInfoTable? = {
        let offset = mathKernInfoOffset()
        if offset != 0 {
            return MathKernInfoTable(base: self.base + Int(offset), context: context)
        } else {
            return nil
        }
    }()
}

/// The math kerning-table types defined for the four corners of a glyph.
public enum MathKernCorner: Int {
    case TopRight = 0
    case TopLeft = 1
    case BottomRight = 2
    case BottomLeft = 3

    func getOffset() -> Int {
        rawValue * 2
    }
}

public struct MathKernInfoRecord {
    static let byteSize = 8

    /// Offset to MathKern table for top right corner, from the beginning
    /// of the MathKernInfo table. May be NULL.
    public let topRightMathKernOffset: Offset16

    /// Offset to MathKern table for the top left corner, from the beginning
    /// of the MathKernInfo table. May be NULL.
    public let topLeftMathKernOffset: Offset16

    /// Offset to MathKern table for bottom right corner, from the beginning
    /// of the MathKernInfo table. May be NULL.
    public let bottomRightMathKernOffset: Offset16

    /// Offset to MathKern table for bottom left corner, from the beginning
    /// of the MathKernInfo table. May be NULL.
    public let bottomLeftMathKernOffset: Offset16

    init() {
        self.init(topRightMathKernOffset: 0,
                  topLeftMathKernOffset: 0,
                  bottomRightMathKernOffset: 0,
                  bottomLeftMathKernOffset: 0)
    }

    init(topRightMathKernOffset: Offset16,
         topLeftMathKernOffset: Offset16,
         bottomRightMathKernOffset: Offset16,
         bottomLeftMathKernOffset: Offset16)
    {
        self.topRightMathKernOffset = topRightMathKernOffset
        self.topLeftMathKernOffset = topLeftMathKernOffset
        self.bottomRightMathKernOffset = bottomRightMathKernOffset
        self.bottomLeftMathKernOffset = bottomLeftMathKernOffset
    }

    func getMathKernOffset(corner: MathKernCorner) -> Offset16 {
        switch corner {
        case .TopRight:
            return topRightMathKernOffset
        case .TopLeft:
            return topLeftMathKernOffset
        case .BottomRight:
            return bottomRightMathKernOffset
        case .BottomLeft:
            return bottomLeftMathKernOffset
        }
    }

    static func read(ptr: UnsafePointer<UInt8>) -> MathKernInfoRecord {
        MathKernInfoRecord(topRightMathKernOffset: readOffset16(ptr + 0),
                           topLeftMathKernOffset: readOffset16(ptr + 2),
                           bottomRightMathKernOffset: readOffset16(ptr + 4),
                           bottomLeftMathKernOffset: readOffset16(ptr + 6))
    }
}
