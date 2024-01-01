import CoreText

extension CTFont {
    public var mathTable: MathTable? {
        if self.getMathTableData() != nil {
            let table = MathTable(font: self)
            if table.majorVersion == 1 {
                return table
            }
        }
        return nil
    }

    public var pointsPerUnit: CGFloat {
        CTFontGetSize(self) / CGFloat(CTFontGetUnitsPerEm(self))
    }

    func getMathTableData() -> CFData? {
        CTFontCopyTable(self,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}

public class MathTable {
    let font: CTFont

    init(font: CTFont) {
        self.font = font
    }

    // MARK: - Header fields

    /// Major version of the MATH table, = 1.
    public var majorVersion: UInt16 {
        readUInt16(offset: 0)
    }

    /// Minor version of the MATH table, = 0.
    public var minorVersion: UInt16 {
        readUInt16(offset: 2)
    }

    /// Offset to MathConstants table - from the beginning of MATH table.
    public var mathConstantsOffset: Offset16 {
        readOffset16(offset: 4)
    }

    /// Offset to MathGlyphInfo table - from the beginning of MATH table.
    public var mathGlyphInfoOffset: Offset16 {
        readOffset16(offset: 6)
    }

    /// Offset to MathVariants table - from the beginning of MATH table.
    public var mathVariantsOffset: Offset16 {
        readOffset16(offset: 8)
    }

    // MARK: - Math constants

    /// Percentage of scaling down for level 1 superscripts and subscripts.
    /// Suggested value: 80%.
    public var scriptPercentScaleDown: Int16 {
        let offset = MathConstants.getByteOffset(offset: MathConstants.scriptPercentScaleDown)
        return readInt16(parentOffset: mathConstantsOffset, offset: offset)
    }

    /// Percentage of scaling down for level 2 (scriptScript) superscripts and subscripts.
    /// Suggested value: 60%.
    public var scriptScriptPercentScaleDown: Int16 {
        let offset = MathConstants.getByteOffset(offset: MathConstants.scriptScriptPercentScaleDown)
        return readInt16(parentOffset: mathConstantsOffset, offset: offset)
    }

    /// Minimum height required for a delimited expression (contained within parentheses, etc.)
    /// to be treated as a sub-formula. Suggested value: normal line height × 1.5.
    public var delimitedSubFormulaMinHeight: CGFloat {
        let offset = MathConstants.getByteOffset(offset: MathConstants.delimitedSubFormulaMinHeight)
        return CGFloat(readUFWORD(parentOffset: mathConstantsOffset, offset: offset)) * font.pointsPerUnit
    }

    /// Minimum height of n-ary operators (such as integral and summation) for formulas in display
    /// mode (that is, appearing as standalone page elements, not embedded inline within text).
    public var displayOperatorMinHeight: CGFloat {
        let offset = MathConstants.getByteOffset(offset: MathConstants.displayOperatorMinHeight)
        return CGFloat(readUFWORD(parentOffset: mathConstantsOffset, offset: offset)) * font.pointsPerUnit
    }

    /// Height of the bottom of the radical degree, if such is present,
    /// in proportion to the ascender of the radical sign. Suggested: 60%.
    public var radicalDegreeBottomRaisePercent: Int16 {
        let offset = MathConstants.getByteOffset(offset: MathConstants.radicalDegreeBottomRaisePercent)
        return readInt16(parentOffset: mathConstantsOffset, offset: offset)
    }

    // MARK: - Helpers

    /// Read UInt16, in big-endian order, at the given (byte) offset
    func readUInt16(offset: CFIndex) -> UInt16 {
        let ptr = CFDataGetBytePtr(font.getMathTableData()!)!
        return (ptr+offset).withMemoryRebound(to: UInt16.self, capacity: 1) {
            $0.pointee.byteSwapped
        }
    }

    /// Read Int16, in big-endian order, at the given (byte) offset
    func readInt16(offset: CFIndex) -> Int16 {
        let ptr = CFDataGetBytePtr(font.getMathTableData()!)!
        return (ptr+offset).withMemoryRebound(to: Int16.self, capacity: 1) {
            $0.pointee.byteSwapped
        }
    }

    /// Read Offset16, at the given (byte) offset
    func readOffset16(offset: CFIndex) -> Offset16 {
        readUInt16(offset: offset)
    }

    /// Read FWORD, at the given (byte) offset
    func readFWORD(offset: CFIndex) -> FWORD {
        readInt16(offset: offset)
    }

    /// Read UFWORD, at the given (byte) offset
    func readUFWORD(offset: CFIndex) -> UFWORD {
        readUInt16(offset: offset)
    }

    /// Read MathValueRecord, at the given (byte) offset
    func readMathValueRecord(offset: CFIndex) -> MathValueRecord {
        let value = readFWORD(offset: offset)
        let deviceTable = readOffset16(offset: offset + 2)
        return MathValueRecord(value: value, deviceTable: deviceTable)
    }

    /// Read Int16, at the given (byte) offset
    func readInt16(parentOffset: Offset16, offset: CFIndex) -> Int16 {
        readInt16(offset: CFIndex(parentOffset) + offset)
    }

    /// Read UInt16, at the given (byte) offset
    func readUInt16(parentOffset: Offset16, offset: CFIndex) -> UInt16 {
        readUInt16(offset: CFIndex(parentOffset) + offset)
    }

    /// Read Offset16, at the given (byte) offset
    func readOffset16(parentOffset: Offset16, offset: CFIndex) -> Offset16 {
        readOffset16(offset: CFIndex(parentOffset) + offset)
    }

    /// Read FWORD, at the given (byte) offset
    func readFWORD(parentOffset: Offset16, offset: CFIndex) -> FWORD {
        readFWORD(offset: CFIndex(parentOffset) + offset)
    }

    /// Read UFWORD, at the given (byte) offset
    func readUFWORD(parentOffset: Offset16, offset: CFIndex) -> UFWORD {
        readUFWORD(offset: CFIndex(parentOffset) + offset)
    }

    /// Read MathValueRecord, at the given (byte) offset
    func readMathValueRecord(parentOffset: Offset16, offset: CFIndex) -> MathValueRecord {
        readMathValueRecord(offset: CFIndex(parentOffset) + offset)
    }
}

typealias FWORD = Int16     // int16 that describes a quantity in font design units.
typealias UFWORD = UInt16   // uint16 that describes a quantity in font design units.
public typealias Offset16 = UInt16 // Short offset to a table, same as uint16, NULL offset = 0x0000

struct MathValueRecord {
    let value: FWORD          // The X or Y value in design units
    let deviceTable: Offset16 // Offset to the device table — from the beginning of parent table.
                              // May be NULL. Suggested format for device table is 1.

    init() {
        self.init(value: 0, deviceTable: 0)
    }

    init(value: FWORD, deviceTable: Offset16) {
        self.value = value
        self.deviceTable = deviceTable
    }
}

public enum MathConstants {
    public static let
        scriptPercentScaleDown = 0,
        scriptScriptPercentScaleDown = 1,
        delimitedSubFormulaMinHeight = 2,
        displayOperatorMinHeight = 3,
        mathLeading = 4,
        axisHeight = 5,
        accentBaseHeight = 6,
        flattenedAccentBaseHeight = 7,
        subscriptShiftDown = 8,
        subscriptTopMax = 9,
        subscriptBaselineDropMin = 10,
        superscriptShiftUp = 11,
        superscriptShiftUpCramped = 12,
        superscriptBottomMin = 13,
        superscriptBaselineDropMax = 14,
        subSuperscriptGapMin = 15,
        superscriptBottomMaxWithSubscript = 16,
        spaceAfterScript = 17,
        upperLimitGapMin = 18,
        upperLimitBaselineRiseMin = 19,
        lowerLimitGapMin = 20,
        lowerLimitBaselineDropMin = 21,
        stackTopShiftUp = 22,
        stackTopDisplayStyleShiftUp = 23,
        stackBottomShiftDown = 24,
        stackBottomDisplayStyleShiftDown = 25,
        stackGapMin  = 26,
        stackDisplayStyleGapMin = 27,
        stretchStackTopShiftUp = 28,
        stretchStackBottomShiftDown = 29,
        stretchStackGapAboveMin = 30,
        stretchStackGApBelowMin = 31,
        fractionNumeratorShiftUp = 32,
        fractionNumeratorDisplayStyleShiftUp = 33,
        fractionDenominatorShiftDown = 34,
        fractionDenominatorDisplayStyleShiftDown = 35,
        fractionNumeratorGapMin = 36,
        fractionNumDisplayStyleGapMin = 37,
        fractionRuleThickness = 38,
        fractionDenominatorGapMin = 39,
        fractionDenomDisplayStyleGapMin = 40,
        skewedFractionHorizontalGap = 41,
        skewedFractionVerticalGap = 42,
        overbarVerticalGap = 43,
        overbarRuleThickness = 44,
        overbarExtraAscender = 45,
        underbarVerticalGap = 46,
        underbarRuleThickness = 47,
        underbarExtraDescender = 48,
        radicalVerticalGap = 49,
        radicalDisplayStyleVerticalGap = 50,
        radicalRuleThickness = 51,
        radicalExtraAscender = 52,
        radicalKernBeforeDegree = 53,
        radicalKernAfterDegree = 54,
        radicalDegreeBottomRaisePercent = 55

    public static func getByteOffset(offset: CFIndex) -> CFIndex {
        precondition(0 <= offset && offset <= radicalDegreeBottomRaisePercent)

        if (offset < mathLeading) {
            return offset * 2
        }
        else {
            return mathLeading * 2 + (offset - mathLeading) * 4
        }
    }
}

class MathConstantsCache {
    init() {
        percentScaleDown = [Int16](repeating: 0, count: 2)
        minHeight = [UFWORD](repeating: 0, count: 2)
        mathValueRecords = [MathValueRecord](repeating: MathValueRecord(), count: 51)
        radicalDegreeBottomRaisePercent = 0
    }

    var percentScaleDown: [Int16]           // count: 2
    var minHeight: [UFWORD]                 // count: 2
    var mathValueRecords: [MathValueRecord] // count: 51
    var radicalDegreeBottomRaisePercent: Int16 // count: 1
}
