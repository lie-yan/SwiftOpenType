import CoreText

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
        data.readUInt16(0)
    }

    /// Minor version of the MATH table, = 0.
    public var minorVersion: UInt16 {
        data.readUInt16(2)
    }

    /// Offset to MathConstants table - from the beginning of MATH table.
    var mathConstantsOffset: Offset16 {
        data.readOffset16(4)
    }

    /// Offset to MathGlyphInfo table - from the beginning of MATH table.
    var mathGlyphInfoOffset: Offset16 {
        data.readOffset16(6)
    }

    /// Offset to MathVariants table - from the beginning of MATH table.
    var mathVariantsOffset: Offset16 {
        data.readOffset16(8)
    }

    // MARK: - Sub-tables

    public var mathConstantsTable: MathConstantsTable {
        MathConstantsTable(mathTable: self)
    }

    public var mathGlyphInfoTable: MathGlyphInfoTable {
        MathGlyphInfoTable(mathTable: self)
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
    let font: CTFont
    let data: CFData
    let mathConstantsOffset: Offset16

    init(mathTable: MathTable) {
        self.font = mathTable.font
        self.data = mathTable.data
        self.mathConstantsOffset = mathTable.mathConstantsOffset
    }

    /// Return the value of the math constant specified by the argument whose value
    /// should be taken from ``MathConstants``.
    public func getMathConstant(_ index: Int) -> CGFloat {
        precondition(index >= 0 && index <= MathConstants.radicalDegreeBottomRaisePercent)

        let byteOffset = MathConstants.getByteOffset(index: index)

        if (index <= MathConstants.scriptScriptPercentScaleDown) {
            let value = data.readInt16(parentOffset: mathConstantsOffset, offset: byteOffset)
            return CGFloat(value) / 100
        }
        else if (index <= MathConstants.displayOperatorMinHeight) {
            let value = data.readUFWORD(parentOffset: mathConstantsOffset, offset: byteOffset)
            return CGFloat(value) * font.sizePerUnit()
        }
        else if (index <= MathConstants.radicalKernAfterDegree) {
            let mathValueRecord = data.readMathValueRecord(parentOffset: mathConstantsOffset, offset: byteOffset)
            let value = data.evalMathValueRecord(parentOffset: mathConstantsOffset, mathValueRecord: mathValueRecord)
            return CGFloat(value) * font.sizePerUnit()
        }
        else if (index == MathConstants.radicalDegreeBottomRaisePercent) {
            let value = data.readInt16(parentOffset: mathConstantsOffset, offset: byteOffset)
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
    static func getByteOffset(index: Int) -> Int {
        precondition(index >= 0 && index <= radicalDegreeBottomRaisePercent)

        if (index < mathLeading) {
            return index * 2
        }
        else {
            return mathLeading * 2 + (index - mathLeading) * 4
        }
    }
}

public class MathGlyphInfoTable {
    let data: CFData
    let mathGlyphInfoOffset: Offset16

    init(mathTable: MathTable) {
        self.data = mathTable.data
        self.mathGlyphInfoOffset = mathTable.mathGlyphInfoOffset
    }

    // MARK: - Header fields

    /// Offset to MathItalicsCorrectionInfo table, from the beginning of the MathGlyphInfo table.
    var mathItalicsCorrectionInfoOffset: Offset16 {
        data.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 0)
    }

    /// Offset to MathTopAccentAttachment table, from the beginning of the MathGlyphInfo table.
    var mathTopAccentAttachmentOffset: Offset16 {
        data.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 2)
    }

    /// Offset to ExtendedShapes coverage table, from the beginning of the MathGlyphInfo table.
    /// When the glyph to the left or right of a box is an extended shape variant, the (ink) box
    /// should be used for vertical positioning purposes, not the default position defined by
    /// values in MathConstants table. May be NULL.
    var extendedShapeCoverageOffset: Offset16 {
        data.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 4)
    }

    /// Offset to MathKernInfo table, from the beginning of the MathGlyphInfo table.
    var mathKernInfoOffset: Offset16 {
        data.readOffset16(parentOffset: mathGlyphInfoOffset, offset: 6)
    }

    /// MARK: - Sub-tables

    public var mathItalicsCorrectionInfoTable: MathItalicsCorrectionInfoTable {
        MathItalicsCorrectionInfoTable(mathGlyphInfoTable: self)
    }
}

public class MathItalicsCorrectionInfoTable {
    let data: CFData
    let mathItalicsCorrectionInfoOffset: Offset16 /// offset from the beginning of MATH table

    init(mathGlyphInfoTable: MathGlyphInfoTable) {
        self.data = mathGlyphInfoTable.data
        self.mathItalicsCorrectionInfoOffset = mathGlyphInfoTable.mathGlyphInfoOffset + mathGlyphInfoTable.mathItalicsCorrectionInfoOffset
    }

    /// Offset to Coverage table - from the beginning of MathItalicsCorrectionInfo table.
    var italicsCorrectionCoverageOffset: Offset16 {
        data.readOffset16(parentOffset: mathItalicsCorrectionInfoOffset, offset: 0)
    }

    /// Number of italics correction values. Should coincide with the number of covered glyphs.
    var italicsCorrectionCount: UInt16 {
        data.readUInt16(parentOffset: mathItalicsCorrectionInfoOffset, offset: 2)
    }

    /// Array of MathValueRecords defining italics correction values for each covered glyph.
    func italicsCorrection(_ index: Int) -> MathValueRecord {
        data.readMathValueRecord(parentOffset: mathItalicsCorrectionInfoOffset, offset: 4 + index * 4)
    }

    public var coverageTable: CoverageTable {
        CoverageTable(data: data, coverageOffset: mathItalicsCorrectionInfoOffset + italicsCorrectionCoverageOffset)
    }

    func italicsCorrection(glyph: CGGlyph) -> CGFloat {
        // TODO: implement
        return 0
    }
}

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

