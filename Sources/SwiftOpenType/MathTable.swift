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

    public var sizePerUnit: CGFloat {
        CTFontGetSize(self) / CGFloat(CTFontGetUnitsPerEm(self))
    }

    func getMathTableData() -> CFData? {
        CTFontCopyTable(self,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}

/**
 The MATH table
 */
public class MathTable {
    let font: CTFont
    let data: CFData

    init(font: CTFont) {
        self.font = font
        self.data = font.getMathTableData()!
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
    var mathConstantsOffset: Offset16 {
        readOffset16(offset: 4)
    }

    /// Offset to MathGlyphInfo table - from the beginning of MATH table.
    var mathGlyphInfoOffset: Offset16 {
        readOffset16(offset: 6)
    }

    /// Offset to MathVariants table - from the beginning of MATH table.
    var mathVariantsOffset: Offset16 {
        readOffset16(offset: 8)
    }

    // MARK: - Sub-tables

    public var mathConstantsTable: MathConstantsTable {
        MathConstantsTable(mathTable: self, mathConstantsOffset: mathConstantsOffset)
    }

    public var mathGlyphInfoTable: MathGlyphInfoTable {
        MathGlyphInfoTable(mathTable: self, mathGlyphInfoOffset: mathGlyphInfoOffset)
    }

    // MARK: - Helpers

    /// Read UInt16, in big-endian order, at the given (byte) offset
    func readUInt16(offset: CFIndex) -> UInt16 {
        let ptr = CFDataGetBytePtr(data)!
        return (ptr+offset).withMemoryRebound(to: UInt16.self, capacity: 1) {
            $0.pointee.byteSwapped
        }
    }

    /// Read Int16, in big-endian order, at the given (byte) offset
    func readInt16(offset: CFIndex) -> Int16 {
        let ptr = CFDataGetBytePtr(data)!
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
        let deviceOffset = readOffset16(offset: offset + 2)
        return MathValueRecord(value: value, deviceOffset: deviceOffset)
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

    /// Read adjustment from device table
    func readDeviceDelta(parentOffset: Offset16, deviceOffset: Offset16) -> Int16 {
        // TODO: add device delta
        if (deviceOffset != 0) {
            print("device table present at offset \(parentOffset): \(deviceOffset); \(font)")
            let deviceTable = parentOffset + deviceOffset
            let startSize = readUInt16(parentOffset: deviceTable, offset: 0)
            let endSize = readUInt16(parentOffset: deviceTable, offset: 2)
            let deltaFormat = readUInt16(parentOffset: deviceTable, offset: 4)
            let first16 = readUInt16(parentOffset: deviceTable, offset: 6)
            print(" sizes: \(startSize) to \(endSize); format: \(deltaFormat); first word: \(first16)")
        }
        return 0
    }

    /// Evaluate MathValueRecord, at the given (byte) offset
    func evalMathValueRecord(parentOffset: Offset16, offset: CFIndex) -> Int32 {
        let mathValueRecord = readMathValueRecord(parentOffset: parentOffset, offset: offset)
        let deltaValue = readDeviceDelta(parentOffset: parentOffset, deviceOffset: mathValueRecord.deviceOffset)
        return Int32(mathValueRecord.value) + Int32(deltaValue)
    }
}

/**
 The MathConstants table

 For more details, refer to [MathConstants Table](https://docs.microsoft.com/en-us/typography/opentype/spec/math#mathconstants-table)
 of the OpenType specification.

 Below is the correspondence between OpenType parameters and TeX parameters.
 For an illustrated exposition, refer to _Ulrik Vieth (2009). OpenType math illuminated._

 | OpenType parameter                       | TeX parameter
 | -----------------------------------------|----------------------------------
 | scriptPercentScaleDown                   | e.g. 70-80 %
 | scriptScriptPercentScaleDown             | e.g. 50-60 %
 | (no correspondence)                      | σ20 (e.g. 20-24 pt)
 | delimitedSubFormulaMinHeight             | σ21 (e.g. 10-12 pt)
 | displayOperatorMinHeight                 | ?? (e.g. 12-15 pt)
 | mathLeading                              | unused
 | axisHeight                               | σ22 (axis height)
 | accentBaseHeight                         | σ5 (x-height)
 | flattenedAccentBaseHeight                | ?? (capital height)
 | subscriptShiftDown                       | σ16, σ17
 | subscriptTopMax                          | (= 4/5 σ5)
 | subscriptBaselineDropMin                 | σ19
 | superscriptShiftUp                       | σ13, σ14
 | superscriptShiftUpCramped                | σ15
 | superscriptBottomMin                     | (= 1/4 σ5)
 | superscriptBaselineDropMax               | σ18
 | subSuperscriptGapMin                     | (= 4 ξ8)
 | superscriptBottomMaxWithSubscript        | (= 4/5 σ5)
 | spaceAfterScript                         | \scriptspace
 | upperLimitGapMin                         | ξ9
 | upperLimitBaselineRiseMin                | ξ11
 | lowerLimitGapMin                         | ξ10
 | lowerLimitBaselineDropMin                | ξ12
 | (no correspondence)                      | ξ13
 | stackTopShiftUp                          | σ10
 | stackTopDisplayStyleShiftUp              | σ8
 | stackBottomShiftDown                     | σ12
 | stackBottomDisplayStyleShiftDown         | σ11
 | stackGapMin                              | (= 3 ξ8)
 | stackDisplayStyleGapMin                  | (= 7 ξ8)
 | stretchStackTopShiftUp                   | ξ11
 | stretchStackBottomShiftDown              | ξ12
 | stretchStackGapAboveMin                  | ξ9
 | stretchStackGapBelowMin                  | ξ10
 | fractionNumeratorShiftUp                 | σ9
 | fractionNumeratorDisplayStyleShiftUp     | σ8
 | fractionDenominatorShiftDown             | σ12
 | fractionDenominatorDisplayStyleShiftDown | σ11
 | fractionNumeratorGapMin                  | (= ξ8)
 | fractionNumDisplayStyleGapMin            | (= 3 ξ8)
 | fractionRuleThickness                    | (= ξ8)
 | fractionDenominatorGapMin                | (= ξ8)
 | fractionDenomDisplayStyleGapMin          | (= 3 ξ8)
 | skewedFractionHorizontalGap              |
 | skewedFractionVerticalGap                |
 | overbarVerticalGap                       | (= 3 ξ8)
 | overbarRuleThickness                     | (= ξ8)
 | overbarExtraAscender                     | (= ξ8)
 | underbarVerticalGap                      | (= 3 ξ8)
 | underbarRuleThickness                    | (= ξ8)
 | underbarExtraDescender                   | (= ξ8)
 | radicalVerticalGap                       | (= ξ8 + 1/4 ξ8)
 | radicalDisplayStyleVerticalGap           | (= ξ8 + 1/4 σ5)
 | radicalRuleThickness                     | (= ξ8)
 | radicalExtraAscender                     | (= ξ8)
 | radicalKernBeforeDegree                  | e.g. 5/18 em
 | radicalKernAfterDegree                   | e.g. 10/18 em
 | radicalDegreeBottomRaisePercent          | e.g. 60 %

 | Parameter                                | Notation
 | -----------------------------------------|----------------------------------
 | x_height                                 | σ5
 | quad                                     | σ6
 | sup1                                     | σ13
 | sup2                                     | σ14
 | sup3                                     | σ15
 | sub1                                     | σ16
 | sub2                                     | σ17
 | sup_drop                                 | σ18
 | sub_drop                                 | σ19
 | axis_height                              | σ22
 | default_rule_thickness                   | ξ8
 | math unit                                | σ6 / 18
 | math quad                                | σ6
 | thin space                               | normally 1/6 σ6  (= 3mu)
 | medium space                             | normally 2/9 σ6  (= 4mu)
 | thick space                              | normally 5/18 σ6 (= 5mu)
 */
public class MathConstantsTable {
    let mathTable: MathTable
    let mathConstantsOffset: Offset16

    init(mathTable: MathTable, mathConstantsOffset: Offset16) {
        self.mathTable = mathTable
        self.mathConstantsOffset = mathConstantsOffset
    }

    /// Return the value of the math constant specified by the argument whose value
    /// should be taken from ``MathConstants``.
    public func getMathConstant(_ offset: CFIndex) -> CGFloat {
        precondition(offset >= 0 && offset <= MathConstants.radicalDegreeBottomRaisePercent)

        let byteOffset = MathConstants.getByteOffset(offset: offset)

        if (offset <= MathConstants.scriptScriptPercentScaleDown) {
            let value = mathTable.readInt16(parentOffset: mathConstantsOffset, offset: byteOffset)
            return CGFloat(value) / 100
        }
        else if (offset <= MathConstants.displayOperatorMinHeight) {
            let value = mathTable.readUFWORD(parentOffset: mathConstantsOffset, offset: byteOffset)
            return CGFloat(value) * mathTable.font.sizePerUnit
        }
        else if (offset <= MathConstants.radicalKernAfterDegree) {
            let value = mathTable.evalMathValueRecord(parentOffset: mathConstantsOffset, offset: byteOffset)
            return CGFloat(value) * mathTable.font.sizePerUnit
        }
        else if (offset == MathConstants.radicalDegreeBottomRaisePercent) {
            let value = mathTable.readInt16(parentOffset: mathConstantsOffset, offset: byteOffset)
            return CGFloat(value) / 100
        }

        assert(false)
    }

    public var scriptPercentScaleDown: CGFloat {
        getMathConstant(MathConstants.scriptPercentScaleDown)
    }

    public var scriptScriptPercentScaleDown: CGFloat {
        getMathConstant(MathConstants.scriptScriptPercentScaleDown)
    }

    public var delimitedSubFormulaMinHeight: CGFloat {
        getMathConstant(MathConstants.delimitedSubFormulaMinHeight)
    }

    public var displayOperatorMinHeight: CGFloat {
        getMathConstant(MathConstants.displayOperatorMinHeight)
    }

    public var mathLeading: CGFloat {
        getMathConstant(MathConstants.mathLeading)
    }

    public var axisHeight: CGFloat {
        getMathConstant(MathConstants.axisHeight)
    }

    public var accentBaseHeight: CGFloat {
        getMathConstant(MathConstants.accentBaseHeight)
    }

    public var flattenedAccentBaseHeight: CGFloat {
        getMathConstant(MathConstants.flattenedAccentBaseHeight)
    }

    public var subscriptShiftDown: CGFloat {
        getMathConstant(MathConstants.subscriptShiftDown)
    }

    public var subscriptTopMax: CGFloat {
        getMathConstant(MathConstants.subscriptTopMax)
    }

    public var subscriptBaselineDropMin: CGFloat {
        getMathConstant(MathConstants.subscriptBaselineDropMin)
    }

    public var superscriptShiftUp: CGFloat {
        getMathConstant(MathConstants.superscriptShiftUp)
    }

    public var superscriptShiftUpCramped: CGFloat {
        getMathConstant(MathConstants.superscriptShiftUpCramped)
    }

    public var superscriptBottomMin: CGFloat {
        getMathConstant(MathConstants.superscriptBottomMin)
    }

    public var superscriptBaselineDropMax: CGFloat {
        getMathConstant(MathConstants.superscriptBaselineDropMax)
    }

    public var subSuperscriptGapMin: CGFloat {
        getMathConstant(MathConstants.subSuperscriptGapMin)
    }

    public var superscriptBottomMaxWithSubscript: CGFloat {
        getMathConstant(MathConstants.superscriptBottomMaxWithSubscript)
    }

    public var spaceAfterScript: CGFloat {
        getMathConstant(MathConstants.spaceAfterScript)
    }

    public var upperLimitGapMin: CGFloat {
        getMathConstant(MathConstants.upperLimitGapMin)
    }

    public var upperLimitBaselineRiseMin: CGFloat {
        getMathConstant(MathConstants.upperLimitBaselineRiseMin)
    }

    public var lowerLimitGapMin: CGFloat {
        getMathConstant(MathConstants.lowerLimitGapMin)
    }

    public var lowerLimitBaselineDropMin: CGFloat {
        getMathConstant(MathConstants.lowerLimitBaselineDropMin)
    }

    public var stackTopShiftUp: CGFloat {
        getMathConstant(MathConstants.stackTopShiftUp)
    }

    public var stackTopDisplayStyleShiftUp: CGFloat {
        getMathConstant(MathConstants.stackTopDisplayStyleShiftUp)
    }

    public var stackBottomShiftDown: CGFloat {
        getMathConstant(MathConstants.stackBottomShiftDown)
    }

    public var stackBottomDisplayStyleShiftDown: CGFloat {
        getMathConstant(MathConstants.stackBottomDisplayStyleShiftDown)
    }

    public var stackGapMin: CGFloat {
        getMathConstant(MathConstants.stackGapMin)
    }

    public var stackDisplayStyleGapMin: CGFloat {
        getMathConstant(MathConstants.stackDisplayStyleGapMin)
    }

    public var stretchStackTopShiftUp: CGFloat {
        getMathConstant(MathConstants.stretchStackTopShiftUp)
    }

    public var stretchStackBottomShiftDown: CGFloat {
        getMathConstant(MathConstants.stretchStackBottomShiftDown)
    }

    public var stretchStackGapAboveMin: CGFloat {
        getMathConstant(MathConstants.stretchStackGapAboveMin)
    }

    public var stretchStackGapBelowMin: CGFloat {
        getMathConstant(MathConstants.stretchStackGapBelowMin)
    }

    public var fractionNumeratorShiftUp: CGFloat {
        getMathConstant(MathConstants.fractionNumeratorShiftUp)
    }

    public var fractionNumeratorDisplayStyleShiftUp: CGFloat {
        getMathConstant(MathConstants.fractionNumeratorDisplayStyleShiftUp)
    }

    public var fractionDenominatorShiftDown: CGFloat {
        getMathConstant(MathConstants.fractionDenominatorShiftDown)
    }

    public var fractionDenominatorDisplayStyleShiftDown: CGFloat {
        getMathConstant(MathConstants.fractionDenominatorDisplayStyleShiftDown)
    }

    public var fractionNumeratorGapMin: CGFloat {
        getMathConstant(MathConstants.fractionNumeratorGapMin)
    }

    public var fractionNumDisplayStyleGapMin: CGFloat {
        getMathConstant(MathConstants.fractionNumDisplayStyleGapMin)
    }

    public var fractionRuleThickness: CGFloat {
        getMathConstant(MathConstants.fractionRuleThickness)
    }

    public var fractionDenominatorGapMin: CGFloat {
        getMathConstant(MathConstants.fractionDenominatorGapMin)
    }

    public var fractionDenomDisplayStyleGapMin: CGFloat {
        getMathConstant(MathConstants.fractionDenomDisplayStyleGapMin)
    }

    public var skewedFractionHorizontalGap: CGFloat {
        getMathConstant(MathConstants.skewedFractionHorizontalGap)
    }

    public var skewedFractionVerticalGap: CGFloat {
        getMathConstant(MathConstants.skewedFractionVerticalGap)
    }

    public var overbarVerticalGap: CGFloat {
        getMathConstant(MathConstants.overbarVerticalGap)
    }

    public var overbarRuleThickness: CGFloat {
        getMathConstant(MathConstants.overbarRuleThickness)
    }

    public var overbarExtraAscender: CGFloat {
        getMathConstant(MathConstants.overbarExtraAscender)
    }

    public var underbarVerticalGap: CGFloat {
        getMathConstant(MathConstants.underbarVerticalGap)
    }

    public var underbarRuleThickness: CGFloat {
        getMathConstant(MathConstants.underbarRuleThickness)
    }

    public var underbarExtraDescender: CGFloat {
        getMathConstant(MathConstants.underbarExtraDescender)
    }

    public var radicalVerticalGap: CGFloat {
        getMathConstant(MathConstants.radicalVerticalGap)
    }

    public var radicalDisplayStyleVerticalGap: CGFloat {
        getMathConstant(MathConstants.radicalDisplayStyleVerticalGap)
    }

    public var radicalRuleThickness: CGFloat {
        getMathConstant(MathConstants.radicalRuleThickness)
    }

    public var radicalExtraAscender: CGFloat {
        getMathConstant(MathConstants.radicalExtraAscender)
    }

    public var radicalKernBeforeDegree: CGFloat {
        getMathConstant(MathConstants.radicalKernBeforeDegree)
    }

    public var radicalKernAfterDegree: CGFloat {
        getMathConstant(MathConstants.radicalKernAfterDegree)
    }

    public var radicalDegreeBottomRaisePercent: CGFloat {
        getMathConstant(MathConstants.radicalDegreeBottomRaisePercent)
    }
}

/// The math constant index
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
        stretchStackGapBelowMin = 31,

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

    /// Given element offset, return byte offset
    static func getByteOffset(offset: CFIndex) -> CFIndex {
        precondition(offset >= 0 && offset <= radicalDegreeBottomRaisePercent)

        if (offset < mathLeading) {
            return offset * 2
        }
        else {
            return mathLeading * 2 + (offset - mathLeading) * 4
        }
    }
}

public class MathGlyphInfoTable {
    let mathTable: MathTable
    let mathGlyphInfoOffset: Offset16

    init(mathTable: MathTable, mathGlyphInfoOffset: Offset16) {
        self.mathTable = mathTable
        self.mathGlyphInfoOffset = mathGlyphInfoOffset
    }

    // MARK: - Header fields

    /// Offset to MathItalicsCorrectionInfo table, from the beginning of the MathGlyphInfo table.
    var mathItalicsCorrectionInfoOffset: Offset16 {
        mathTable.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 0)
    }

    /// Offset to MathTopAccentAttachment table, from the beginning of the MathGlyphInfo table.
    var mathTopAccentAttachmentOffset: Offset16 {
        mathTable.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 2)
    }

    /// Offset to ExtendedShapes coverage table, from the beginning of the MathGlyphInfo table.
    /// When the glyph to the left or right of a box is an extended shape variant, the (ink) box
    /// should be used for vertical positioning purposes, not the default position defined by
    /// values in MathConstants table. May be NULL.
    var extendedShapeCoverageOffset: Offset16 {
        mathTable.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 4)
    }

    /// Offset to MathKernInfo table, from the beginning of the MathGlyphInfo table.
    var mathKernInfoOffset: Offset16 {
        mathTable.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 6)
    }
}

typealias FWORD = Int16     // int16 that describes a quantity in font design units.
typealias UFWORD = UInt16   // uint16 that describes a quantity in font design units.
typealias Offset16 = UInt16 // Short offset to a table, same as uint16, NULL offset = 0x0000

struct MathValueRecord {
    let value: FWORD           // The X or Y value in design units
    let deviceOffset: Offset16 // Offset to the device table — from the beginning of parent table.
                               // May be NULL. Suggested format for device table is 1.

    init() {
        self.init(value: 0, deviceOffset: 0)
    }

    init(value: FWORD, deviceOffset: Offset16) {
        self.value = value
        self.deviceOffset = deviceOffset
    }
}
