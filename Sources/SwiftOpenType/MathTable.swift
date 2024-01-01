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

    var pointsPerUnit: CGFloat {
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

    /// White space to be left between math formulas to ensure proper line spacing.
    public var mathLeading: CGFloat {
        getMathConstant(offset: MathConstants.mathLeading)
    }

    /// Axis height of the font.
    public var axisHeight: CGFloat {
        getMathConstant(offset: MathConstants.axisHeight)
    }

    /// Maximum (ink) height of accent base that does not require raising the accents.
    public var accentBaseHeight: CGFloat {
        getMathConstant(offset: MathConstants.accentBaseHeight)
    }

    /// Maximum (ink) height of accent base that does not require flattening the accents.
    public var flattenedAccentBaseHeight: CGFloat {
        getMathConstant(offset: MathConstants.flattenedAccentBaseHeight)
    }

    /// The standard shift down applied to subscript elements. Positive for moving in the downward direction.
    public var subscriptShiftDown: CGFloat {
        getMathConstant(offset: MathConstants.subscriptShiftDown)
    }

    /// Maximum allowed height of the (ink) top of subscripts that does not require moving
    /// subscripts further down. Suggested: 4/5 x- height.
    public var subscriptTopMax: CGFloat {
        getMathConstant(offset: MathConstants.subscriptTopMax)
    }

    /// Minimum allowed drop of the baseline of subscripts relative to the (ink) bottom of the base.
    /// Checked for bases that are treated as a box or extended shape. Positive for subscript
    /// baseline dropped below the base bottom.
    public var subscriptBaselineDropMin: CGFloat {
        getMathConstant(offset: MathConstants.subscriptBaselineDropMin)
    }

    /// Standard shift up applied to superscript elements.
    public var superscriptShiftUp: CGFloat {
        getMathConstant(offset: MathConstants.superscriptShiftUp)
    }

    /// Standard shift of superscripts relative to the base, in cramped style.
    public var superscriptShiftUpCramped: CGFloat {
        getMathConstant(offset: MathConstants.superscriptShiftUpCramped)
    }

    /// Minimum allowed height of the (ink) bottom of superscripts that does not require moving
    /// subscripts further up. Suggested: ¼ x-height.
    public var superscriptBottomMin: CGFloat {
        getMathConstant(offset: MathConstants.superscriptBottomMin)
    }

    /// Maximum allowed drop of the baseline of superscripts relative to the (ink) top of the base.
    /// Checked for bases that are treated as a box or extended shape.
    /// Positive for superscript baseline below the base top.
    public var superscriptBaselineDropMax: CGFloat {
        getMathConstant(offset: MathConstants.superscriptBaselineDropMax)
    }

    /// Minimum gap between the superscript and subscript ink.
    /// Suggested: 4 × default rule thickness.
    public var subSuperscriptGapMin: CGFloat {
        getMathConstant(offset: MathConstants.subSuperscriptGapMin)
    }

    /// The maximum level to which the (ink) bottom of superscript can be pushed to increase the gap
    /// between superscript and subscript, before subscript starts being moved down.
    /// Suggested: 4/5 x-height.
    public var superscriptBottomMaxWithSubscript: CGFloat {
        getMathConstant(offset: MathConstants.superscriptBottomMaxWithSubscript)
    }

    /// Extra white space to be added after each subscript and superscript.
    /// Suggested: 0.5 pt for a 12 pt font. (Note that, in some math layout implementations,
    /// a constant value, such as 0.5 pt, may be used for all text sizes.
    /// Some implementations may use a constant ratio of text size, such as 1/24 of em.)
    public var spaceAfterScript: CGFloat {
        getMathConstant(offset: MathConstants.spaceAfterScript)
    }

    /// Minimum gap between the (ink) bottom of the upper limit, and the (ink) top of the base operator.
    public var upperLimitGapMin: CGFloat {
        getMathConstant(offset: MathConstants.upperLimitGapMin)
    }

    /// Minimum distance between baseline of upper limit and (ink) top of the base operator.
    public var upperLimitBaselineRiseMin: CGFloat {
        getMathConstant(offset: MathConstants.upperLimitBaselineRiseMin)
    }

    /// Minimum gap between (ink) top of the lower limit, and (ink) bottom of the base operator.
    public var lowerLimitGapMin: CGFloat {
        getMathConstant(offset: MathConstants.lowerLimitGapMin)
    }

    /// Minimum distance between baseline of the lower limit and (ink) bottom of the base operator.
    public var lowerLimitBaselineDropMin: CGFloat {
        getMathConstant(offset: MathConstants.lowerLimitBaselineDropMin)
    }

    /// Standard shift up applied to the top element of a stack.
    public var stackTopShiftUp: CGFloat {
        getMathConstant(offset: MathConstants.stackTopShiftUp)
    }

    /// Standard shift up applied to the top element of a stack in display style.
    public var stackTopDisplayStyleShiftUp: CGFloat {
        getMathConstant(offset: MathConstants.stackTopDisplayStyleShiftUp)
    }

    /// Standard shift down applied to the bottom element of a stack.
    /// Positive for moving in the downward direction.
    public var stackBottomShiftDown: CGFloat {
        getMathConstant(offset: MathConstants.stackBottomShiftDown)
    }

    /// Standard shift down applied to the bottom element of a stack in display style.
    /// Positive for moving in the downward direction.
    public var stackBottomDisplayStyleShiftDown: CGFloat {
        getMathConstant(offset: MathConstants.stackBottomDisplayStyleShiftDown)
    }

    /// Minimum gap between (ink) bottom of the top element of a stack, and the (ink) top of the
    /// bottom element. Suggested: 3 × default rule thickness.
    public var stackGapMin: CGFloat {
        getMathConstant(offset: MathConstants.stackGapMin)
    }

    /// Minimum gap between (ink) bottom of the top element of a stack, and the (ink) top of the
    /// bottom element in display style. Suggested: 7 × default rule thickness.
    public var stackDisplayStyleGapMin: CGFloat {
        getMathConstant(offset: MathConstants.stackDisplayStyleGapMin)
    }

    /// Standard shift up applied to the top element of the stretch stack.
    public var stretchStackTopShiftUp: CGFloat {
        getMathConstant(offset: MathConstants.stretchStackTopShiftUp)
    }

    /// Standard shift down applied to the bottom element of the stretch stack.
    /// Positive for moving in the downward direction.
    public var stretchStackBottomShiftDown: CGFloat {
        getMathConstant(offset: MathConstants.stretchStackBottomShiftDown)
    }

    /// Minimum gap between the ink of the stretched element, and the (ink) bottom of the element
    /// above. Suggested: same value as upperLimitGapMin.
    public var stretchStackGapAboveMin: CGFloat {
        getMathConstant(offset: MathConstants.stretchStackGapAboveMin)
    }

    /// Minimum gap between the ink of the stretched element, and the (ink) top of the element
    /// below. Suggested: same value as lowerLimitGapMin.
    public var stretchStackGapBelowMin: CGFloat {
        getMathConstant(offset: MathConstants.stretchStackGapBelowMin)
    }

    /// Standard shift up applied to the numerator.
    public var fractionNumeratorShiftUp: CGFloat {
        getMathConstant(offset: MathConstants.fractionNumeratorShiftUp)
    }

    /// Standard shift up applied to the numerator in display style.
    /// Suggested: same value as stackTopDisplayStyleShiftUp.
    public var fractionNumeratorDisplayStyleShiftUp: CGFloat {
        getMathConstant(offset: MathConstants.fractionNumeratorDisplayStyleShiftUp)
    }

    /// Standard shift down applied to the denominator. Positive for moving in
    /// the downward direction.
    public var fractionDenominatorShiftDown: CGFloat {
        getMathConstant(offset: MathConstants.fractionDenominatorShiftDown)
    }

    /// Standard shift down applied to the denominator in display style.
    /// Positive for moving in the downward direction.
    /// Suggested: same value as stackBottomDisplayStyleShiftDown.
    public var fractionDenominatorDisplayStyleShiftDown: CGFloat {
        getMathConstant(offset: MathConstants.fractionDenominatorDisplayStyleShiftDown)
    }

    /// Minimum tolerated gap between the (ink) bottom of the numerator and the
    /// ink of the fraction bar. Suggested: default rule thickness.
    public var fractionNumeratorGapMin: CGFloat {
        getMathConstant(offset: MathConstants.fractionNumeratorGapMin)
    }

    /// Minimum tolerated gap between the (ink) bottom of the numerator and the
    /// ink of the fraction bar in display style. Suggested: 3 × default rule thickness.
    public var fractionNumDisplayStyleGapMin: CGFloat {
        getMathConstant(offset: MathConstants.fractionNumDisplayStyleGapMin)
    }

    /// Thickness of the fraction bar. Suggested: default rule thickness.
    public var fractionRuleThickness: CGFloat {
        getMathConstant(offset: MathConstants.fractionRuleThickness)
    }

    /// Minimum tolerated gap between the (ink) top of the denominator and the
    /// ink of the fraction bar. Suggested: default rule thickness.
    public var fractionDenominatorGapMin: CGFloat {
        getMathConstant(offset: MathConstants.fractionDenominatorGapMin)
    }

    /// Minimum tolerated gap between the (ink) top of the denominator and the
    /// ink of the fraction bar in display style. Suggested: 3 × default rule thickness.
    public var fractionDenomDisplayStyleGapMin: CGFloat {
        getMathConstant(offset: MathConstants.fractionDenomDisplayStyleGapMin)
    }

    /// Horizontal distance between the top and bottom elements of a skewed fraction.
    public var skewedFractionHorizontalGap: CGFloat {
        getMathConstant(offset: MathConstants.skewedFractionHorizontalGap)
    }

    /// Vertical distance between the ink of the top and bottom elements of a skewed fraction.
    public var skewedFractionVerticalGap: CGFloat {
        getMathConstant(offset: MathConstants.skewedFractionVerticalGap)
    }

    /// Distance between the overbar and the (ink) top of he base.
    /// Suggested: 3 × default rule thickness.
    public var overbarVerticalGap: CGFloat {
        getMathConstant(offset: MathConstants.overbarVerticalGap)
    }

    /// Thickness of overbar. Suggested: default rule thickness.
    public var overbarRuleThickness: CGFloat {
        getMathConstant(offset: MathConstants.overbarRuleThickness)
    }

    /// Extra white space reserved above the overbar. Suggested: default rule thickness.
    public var overbarExtraAscender: CGFloat {
        getMathConstant(offset: MathConstants.overbarExtraAscender)
    }

    /// Distance between underbar and (ink) bottom of the base.
    /// Suggested: 3 × default rule thickness.
    public var underbarVerticalGap: CGFloat {
        getMathConstant(offset: MathConstants.underbarVerticalGap)
    }

    /// Thickness of underbar. Suggested: default rule thickness.
    public var underbarRuleThickness: CGFloat {
        getMathConstant(offset: MathConstants.underbarRuleThickness)
    }

    /// Extra white space reserved below the underbar. Always positive.
    /// Suggested: default rule thickness.
    public var underbarExtraDescender: CGFloat {
        getMathConstant(offset: MathConstants.underbarExtraDescender)
    }

    /// Space between the (ink) top of the expression and the bar over it.
    /// Suggested: 1¼ default rule thickness.
    public var radicalVerticalGap: CGFloat {
        getMathConstant(offset: MathConstants.radicalVerticalGap)
    }

    /// Space between the (ink) top of the expression and the bar over it.
    /// Suggested: default rule thickness + ¼ x-height.
    public var radicalDisplayStyleVerticalGap: CGFloat {
        getMathConstant(offset: MathConstants.radicalDisplayStyleVerticalGap)
    }

    /// Thickness of the radical rule. This is the thickness of the rule in
    /// designed or constructed radical signs. Suggested: default rule thickness.
    public var radicalRuleThickness: CGFloat {
        getMathConstant(offset: MathConstants.radicalRuleThickness)
    }

    /// Extra white space reserved above the radical.
    /// Suggested: same value as radicalRuleThickness.
    public var radicalExtraAscender: CGFloat {
        getMathConstant(offset: MathConstants.radicalExtraAscender)
    }

    /// Extra horizontal kern before the degree of a radical, if such is present.
    /// Suggested: 5/18 of em.
    public var radicalKernBeforeDegree: CGFloat {
        getMathConstant(offset: MathConstants.radicalKernBeforeDegree)
    }

    /// Negative kern after the degree of a radical, if such is present.
    /// Suggested: −10/18 of em.
    public var radicalKernAfterDegree: CGFloat {
        getMathConstant(offset: MathConstants.radicalKernAfterDegree)
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
        return MathValueRecord(value: value, deviceOffset: deviceTable)
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
        // TODO: add device adjustment
        0
    }

    /// Evaluate MathValueRecord, at the given (byte) offset
    func evalMathValueRecord(parentOffset: Offset16, offset: CFIndex) -> CGFloat {
        let mathValueRecord = readMathValueRecord(parentOffset: parentOffset, offset: offset)
        let adjustment = readDeviceDelta(parentOffset: parentOffset, deviceOffset: mathValueRecord.deviceOffset)
        return CGFloat(mathValueRecord.value + adjustment) * font.pointsPerUnit
    }

    /// Evaluate the math constant that is stored as MathValueRecord
    func getMathConstant(offset: CFIndex) -> CGFloat {
        precondition(MathConstants.mathLeading <= offset && offset <= MathConstants.radicalKernAfterDegree)

        let byteOffset = MathConstants.getByteOffset(offset: offset)
        return evalMathValueRecord(parentOffset: mathConstantsOffset, offset: byteOffset)
    }
}

typealias FWORD = Int16     // int16 that describes a quantity in font design units.
typealias UFWORD = UInt16   // uint16 that describes a quantity in font design units.
public typealias Offset16 = UInt16 // Short offset to a table, same as uint16, NULL offset = 0x0000

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
    public static func getByteOffset(offset: CFIndex) -> CFIndex {
        precondition(offset >= 0 && offset <= radicalDegreeBottomRaisePercent)

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
        let count = MathConstants.radicalKernAfterDegree - MathConstants.mathLeading + 1
        assert(count == 51)

        percentScaleDown = [Int16](repeating: 0, count: 2)
        minHeight = [CGFloat](repeating: 0, count: 2)
        mathValueRecords = [CGFloat](repeating: 0, count: count)
        radicalDegreeBottomRaisePercent = 0
    }

    init(font: CTFont) {
        let count = MathConstants.radicalKernAfterDegree - MathConstants.mathLeading + 1
        assert(count == 51)

        if let mathTable = font.mathTable {
            percentScaleDown = [mathTable.scriptPercentScaleDown, mathTable.scriptScriptPercentScaleDown]
            minHeight = [mathTable.delimitedSubFormulaMinHeight, mathTable.displayOperatorMinHeight]

            mathValueRecords = [CGFloat](repeating: 0, count: count)
            for i in 0...count-1 {
                mathValueRecords[i] = mathTable.getMathConstant(offset: i + MathConstants.mathLeading)
            }

            radicalDegreeBottomRaisePercent = mathTable.radicalDegreeBottomRaisePercent
        }
        else {
            percentScaleDown = [Int16](repeating: 0, count: 2)
            minHeight = [CGFloat](repeating: 0, count: 2)
            mathValueRecords = [CGFloat](repeating: 0, count: count)
            radicalDegreeBottomRaisePercent = 0
        }
    }

    var percentScaleDown: [Int16]   // count: 2
    var minHeight: [CGFloat]        // count: 2
    var mathValueRecords: [CGFloat] // count: 51
    var radicalDegreeBottomRaisePercent: Int16 // count: 1
}
