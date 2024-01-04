import CoreText

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
    let data: CFData
    let tableOffset: Offset16

    init(data: CFData, tableOffset: Offset16) {
        self.data = data
        self.tableOffset = tableOffset
    }

    /// Return the value of the math constant specified by the argument whose value
    /// should be taken from ``MathConstants``.
    public func getMathConstant(_ index: Int) -> Int32 {
        precondition(index >= 0 && index <= MathConstants.radicalDegreeBottomRaisePercent)

        if (index <= MathConstants.scriptScriptPercentScaleDown) {
            return getPercent(index)
        }
        else if (index <= MathConstants.displayOperatorMinHeight) {
            return getMinHeight(index)
        }
        else if (index <= MathConstants.radicalKernAfterDegree) {
            return getMathValue(index)
        }
        else if (index == MathConstants.radicalDegreeBottomRaisePercent) {
            return getPercent(index)
        }

        assert(false)
    }

    /// for {scriptPercentScaleDown, scriptScriptPercentScaleDown, radicalDegreeBottomRaisePercent}
    private func getPercent(_ index: Int) -> Int32 {
        let byteOffset = MathConstants.getByteOffset(index: index)
        let value = data.readInt16(parentOffset: tableOffset, offset: byteOffset)
        return Int32(value)
    }

    /// for {delimitedSubFormulaMinHeight, displayOperatorMinHeight}
    private func getMinHeight(_ index: Int) -> Int32 {
        let byteOffset = MathConstants.getByteOffset(index: index)
        let value = data.readUFWORD(parentOffset: tableOffset, offset: byteOffset)
        return Int32(value)
    }

    /// for the remaining
    private func getMathValue(_ index: Int) -> Int32 {
        let byteOffset = MathConstants.getByteOffset(index: index)
        let mathValueRecord = data.readMathValueRecord(parentOffset: tableOffset, offset: byteOffset)
        let value = data.evalMathValueRecord(parentOffset: tableOffset, mathValueRecord: mathValueRecord)
        return Int32(value)
    }

    public var scriptPercentScaleDown: Int32 {
        getPercent(MathConstants.scriptPercentScaleDown)
    }

    public var scriptScriptPercentScaleDown: Int32 {
        getPercent(MathConstants.scriptScriptPercentScaleDown)
    }

    public var delimitedSubFormulaMinHeight: Int32 {
        getMinHeight(MathConstants.delimitedSubFormulaMinHeight)
    }

    public var displayOperatorMinHeight: Int32 {
        getMinHeight(MathConstants.displayOperatorMinHeight)
    }

    public var mathLeading: Int32 {
        getMathValue(MathConstants.mathLeading)
    }

    public var axisHeight: Int32 {
        getMathValue(MathConstants.axisHeight)
    }

    public var accentBaseHeight: Int32 {
        getMathValue(MathConstants.accentBaseHeight)
    }

    public var flattenedAccentBaseHeight: Int32 {
        getMathValue(MathConstants.flattenedAccentBaseHeight)
    }

    public var subscriptShiftDown: Int32 {
        getMathValue(MathConstants.subscriptShiftDown)
    }

    public var subscriptTopMax: Int32 {
        getMathValue(MathConstants.subscriptTopMax)
    }

    public var subscriptBaselineDropMin: Int32 {
        getMathValue(MathConstants.subscriptBaselineDropMin)
    }

    public var superscriptShiftUp: Int32 {
        getMathValue(MathConstants.superscriptShiftUp)
    }

    public var superscriptShiftUpCramped: Int32 {
        getMathValue(MathConstants.superscriptShiftUpCramped)
    }

    public var superscriptBottomMin: Int32 {
        getMathValue(MathConstants.superscriptBottomMin)
    }

    public var superscriptBaselineDropMax: Int32 {
        getMathValue(MathConstants.superscriptBaselineDropMax)
    }

    public var subSuperscriptGapMin: Int32 {
        getMathValue(MathConstants.subSuperscriptGapMin)
    }

    public var superscriptBottomMaxWithSubscript: Int32 {
        getMathValue(MathConstants.superscriptBottomMaxWithSubscript)
    }

    public var spaceAfterScript: Int32 {
        getMathValue(MathConstants.spaceAfterScript)
    }

    public var upperLimitGapMin: Int32 {
        getMathValue(MathConstants.upperLimitGapMin)
    }

    public var upperLimitBaselineRiseMin: Int32 {
        getMathValue(MathConstants.upperLimitBaselineRiseMin)
    }

    public var lowerLimitGapMin: Int32 {
        getMathValue(MathConstants.lowerLimitGapMin)
    }

    public var lowerLimitBaselineDropMin: Int32 {
        getMathValue(MathConstants.lowerLimitBaselineDropMin)
    }

    public var stackTopShiftUp: Int32 {
        getMathValue(MathConstants.stackTopShiftUp)
    }

    public var stackTopDisplayStyleShiftUp: Int32 {
        getMathValue(MathConstants.stackTopDisplayStyleShiftUp)
    }

    public var stackBottomShiftDown: Int32 {
        getMathValue(MathConstants.stackBottomShiftDown)
    }

    public var stackBottomDisplayStyleShiftDown: Int32 {
        getMathValue(MathConstants.stackBottomDisplayStyleShiftDown)
    }

    public var stackGapMin: Int32 {
        getMathValue(MathConstants.stackGapMin)
    }

    public var stackDisplayStyleGapMin: Int32 {
        getMathValue(MathConstants.stackDisplayStyleGapMin)
    }

    public var stretchStackTopShiftUp: Int32 {
        getMathValue(MathConstants.stretchStackTopShiftUp)
    }

    public var stretchStackBottomShiftDown: Int32 {
        getMathValue(MathConstants.stretchStackBottomShiftDown)
    }

    public var stretchStackGapAboveMin: Int32 {
        getMathValue(MathConstants.stretchStackGapAboveMin)
    }

    public var stretchStackGapBelowMin: Int32 {
        getMathValue(MathConstants.stretchStackGapBelowMin)
    }

    public var fractionNumeratorShiftUp: Int32 {
        getMathValue(MathConstants.fractionNumeratorShiftUp)
    }

    public var fractionNumeratorDisplayStyleShiftUp: Int32 {
        getMathValue(MathConstants.fractionNumeratorDisplayStyleShiftUp)
    }

    public var fractionDenominatorShiftDown: Int32 {
        getMathValue(MathConstants.fractionDenominatorShiftDown)
    }

    public var fractionDenominatorDisplayStyleShiftDown: Int32 {
        getMathValue(MathConstants.fractionDenominatorDisplayStyleShiftDown)
    }

    public var fractionNumeratorGapMin: Int32 {
        getMathValue(MathConstants.fractionNumeratorGapMin)
    }

    public var fractionNumDisplayStyleGapMin: Int32 {
        getMathValue(MathConstants.fractionNumDisplayStyleGapMin)
    }

    public var fractionRuleThickness: Int32 {
        getMathValue(MathConstants.fractionRuleThickness)
    }

    public var fractionDenominatorGapMin: Int32 {
        getMathValue(MathConstants.fractionDenominatorGapMin)
    }

    public var fractionDenomDisplayStyleGapMin: Int32 {
        getMathValue(MathConstants.fractionDenomDisplayStyleGapMin)
    }

    public var skewedFractionHorizontalGap: Int32 {
        getMathValue(MathConstants.skewedFractionHorizontalGap)
    }

    public var skewedFractionVerticalGap: Int32 {
        getMathValue(MathConstants.skewedFractionVerticalGap)
    }

    public var overbarVerticalGap: Int32 {
        getMathValue(MathConstants.overbarVerticalGap)
    }

    public var overbarRuleThickness: Int32 {
        getMathValue(MathConstants.overbarRuleThickness)
    }

    public var overbarExtraAscender: Int32 {
        getMathValue(MathConstants.overbarExtraAscender)
    }

    public var underbarVerticalGap: Int32 {
        getMathValue(MathConstants.underbarVerticalGap)
    }

    public var underbarRuleThickness: Int32 {
        getMathValue(MathConstants.underbarRuleThickness)
    }

    public var underbarExtraDescender: Int32 {
        getMathValue(MathConstants.underbarExtraDescender)
    }

    public var radicalVerticalGap: Int32 {
        getMathValue(MathConstants.radicalVerticalGap)
    }

    public var radicalDisplayStyleVerticalGap: Int32 {
        getMathValue(MathConstants.radicalDisplayStyleVerticalGap)
    }

    public var radicalRuleThickness: Int32 {
        getMathValue(MathConstants.radicalRuleThickness)
    }

    public var radicalExtraAscender: Int32 {
        getMathValue(MathConstants.radicalExtraAscender)
    }

    public var radicalKernBeforeDegree: Int32 {
        getMathValue(MathConstants.radicalKernBeforeDegree)
    }

    public var radicalKernAfterDegree: Int32 {
        getMathValue(MathConstants.radicalKernAfterDegree)
    }

    public var radicalDegreeBottomRaisePercent: Int32 {
        getPercent(MathConstants.radicalDegreeBottomRaisePercent)
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
