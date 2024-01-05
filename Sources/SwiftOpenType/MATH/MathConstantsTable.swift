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
    /// should be taken from ``MathConstant``.
    public func getMathConstant(_ index: MathConstant) -> Int32 {
        if (index <= MathConstant.scriptScriptPercentScaleDown) {
            return getPercent(index)
        }
        else if (index <= MathConstant.displayOperatorMinHeight) {
            return getMinHeight(index)
        }
        else if (index <= MathConstant.radicalKernAfterDegree) {
            return getMathValue(index)
        }
        else if (index == MathConstant.radicalDegreeBottomRaisePercent) {
            return getPercent(index)
        }
        
        assert(false)
    }
    
    /// for {scriptPercentScaleDown, scriptScriptPercentScaleDown, radicalDegreeBottomRaisePercent}
    private func getPercent(_ index: MathConstant) -> Int32 {
        let byteOffset = index.getByteOffset()
        let value = data.readInt16(parentOffset: tableOffset, offset: byteOffset)
        return Int32(value)
    }
    
    /// for {delimitedSubFormulaMinHeight, displayOperatorMinHeight}
    private func getMinHeight(_ index: MathConstant) -> Int32 {
        let byteOffset = index.getByteOffset()
        let value = data.readUFWORD(parentOffset: tableOffset, offset: byteOffset)
        return Int32(value)
    }
    
    /// for the remaining
    private func getMathValue(_ index: MathConstant) -> Int32 {
        let byteOffset = index.getByteOffset()
        let mathValueRecord = data.readMathValueRecord(parentOffset: tableOffset, offset: byteOffset)
        let value = data.evalMathValueRecord(parentOffset: tableOffset, mathValueRecord: mathValueRecord)
        return Int32(value)
    }
    
    public var scriptPercentScaleDown: Int32 {
        getPercent(.scriptPercentScaleDown)
    }
    
    public var scriptScriptPercentScaleDown: Int32 {
        getPercent(.scriptScriptPercentScaleDown)
    }
    
    public var delimitedSubFormulaMinHeight: Int32 {
        getMinHeight(.delimitedSubFormulaMinHeight)
    }
    
    public var displayOperatorMinHeight: Int32 {
        getMinHeight(.displayOperatorMinHeight)
    }
    
    public var mathLeading: Int32 {
        getMathValue(.mathLeading)
    }
    
    public var axisHeight: Int32 {
        getMathValue(.axisHeight)
    }
    
    public var accentBaseHeight: Int32 {
        getMathValue(.accentBaseHeight)
    }
    
    public var flattenedAccentBaseHeight: Int32 {
        getMathValue(.flattenedAccentBaseHeight)
    }
    
    public var subscriptShiftDown: Int32 {
        getMathValue(.subscriptShiftDown)
    }
    
    public var subscriptTopMax: Int32 {
        getMathValue(.subscriptTopMax)
    }
    
    public var subscriptBaselineDropMin: Int32 {
        getMathValue(.subscriptBaselineDropMin)
    }
    
    public var superscriptShiftUp: Int32 {
        getMathValue(.superscriptShiftUp)
    }
    
    public var superscriptShiftUpCramped: Int32 {
        getMathValue(.superscriptShiftUpCramped)
    }
    
    public var superscriptBottomMin: Int32 {
        getMathValue(.superscriptBottomMin)
    }
    
    public var superscriptBaselineDropMax: Int32 {
        getMathValue(.superscriptBaselineDropMax)
    }
    
    public var subSuperscriptGapMin: Int32 {
        getMathValue(.subSuperscriptGapMin)
    }
    
    public var superscriptBottomMaxWithSubscript: Int32 {
        getMathValue(.superscriptBottomMaxWithSubscript)
    }
    
    public var spaceAfterScript: Int32 {
        getMathValue(.spaceAfterScript)
    }
    
    public var upperLimitGapMin: Int32 {
        getMathValue(.upperLimitGapMin)
    }
    
    public var upperLimitBaselineRiseMin: Int32 {
        getMathValue(.upperLimitBaselineRiseMin)
    }
    
    public var lowerLimitGapMin: Int32 {
        getMathValue(.lowerLimitGapMin)
    }
    
    public var lowerLimitBaselineDropMin: Int32 {
        getMathValue(.lowerLimitBaselineDropMin)
    }
    
    public var stackTopShiftUp: Int32 {
        getMathValue(.stackTopShiftUp)
    }
    
    public var stackTopDisplayStyleShiftUp: Int32 {
        getMathValue(.stackTopDisplayStyleShiftUp)
    }
    
    public var stackBottomShiftDown: Int32 {
        getMathValue(.stackBottomShiftDown)
    }
    
    public var stackBottomDisplayStyleShiftDown: Int32 {
        getMathValue(.stackBottomDisplayStyleShiftDown)
    }
    
    public var stackGapMin: Int32 {
        getMathValue(.stackGapMin)
    }
    
    public var stackDisplayStyleGapMin: Int32 {
        getMathValue(.stackDisplayStyleGapMin)
    }
    
    public var stretchStackTopShiftUp: Int32 {
        getMathValue(.stretchStackTopShiftUp)
    }
    
    public var stretchStackBottomShiftDown: Int32 {
        getMathValue(.stretchStackBottomShiftDown)
    }
    
    public var stretchStackGapAboveMin: Int32 {
        getMathValue(.stretchStackGapAboveMin)
    }
    
    public var stretchStackGapBelowMin: Int32 {
        getMathValue(.stretchStackGapBelowMin)
    }
    
    public var fractionNumeratorShiftUp: Int32 {
        getMathValue(.fractionNumeratorShiftUp)
    }
    
    public var fractionNumeratorDisplayStyleShiftUp: Int32 {
        getMathValue(.fractionNumeratorDisplayStyleShiftUp)
    }
    
    public var fractionDenominatorShiftDown: Int32 {
        getMathValue(.fractionDenominatorShiftDown)
    }
    
    public var fractionDenominatorDisplayStyleShiftDown: Int32 {
        getMathValue(.fractionDenominatorDisplayStyleShiftDown)
    }
    
    public var fractionNumeratorGapMin: Int32 {
        getMathValue(.fractionNumeratorGapMin)
    }
    
    public var fractionNumDisplayStyleGapMin: Int32 {
        getMathValue(.fractionNumDisplayStyleGapMin)
    }
    
    public var fractionRuleThickness: Int32 {
        getMathValue(.fractionRuleThickness)
    }
    
    public var fractionDenominatorGapMin: Int32 {
        getMathValue(.fractionDenominatorGapMin)
    }
    
    public var fractionDenomDisplayStyleGapMin: Int32 {
        getMathValue(.fractionDenomDisplayStyleGapMin)
    }
    
    public var skewedFractionHorizontalGap: Int32 {
        getMathValue(.skewedFractionHorizontalGap)
    }
    
    public var skewedFractionVerticalGap: Int32 {
        getMathValue(.skewedFractionVerticalGap)
    }
    
    public var overbarVerticalGap: Int32 {
        getMathValue(.overbarVerticalGap)
    }
    
    public var overbarRuleThickness: Int32 {
        getMathValue(.overbarRuleThickness)
    }
    
    public var overbarExtraAscender: Int32 {
        getMathValue(.overbarExtraAscender)
    }
    
    public var underbarVerticalGap: Int32 {
        getMathValue(.underbarVerticalGap)
    }
    
    public var underbarRuleThickness: Int32 {
        getMathValue(.underbarRuleThickness)
    }
    
    public var underbarExtraDescender: Int32 {
        getMathValue(.underbarExtraDescender)
    }
    
    public var radicalVerticalGap: Int32 {
        getMathValue(.radicalVerticalGap)
    }
    
    public var radicalDisplayStyleVerticalGap: Int32 {
        getMathValue(.radicalDisplayStyleVerticalGap)
    }
    
    public var radicalRuleThickness: Int32 {
        getMathValue(.radicalRuleThickness)
    }
    
    public var radicalExtraAscender: Int32 {
        getMathValue(.radicalExtraAscender)
    }
    
    public var radicalKernBeforeDegree: Int32 {
        getMathValue(.radicalKernBeforeDegree)
    }
    
    public var radicalKernAfterDegree: Int32 {
        getMathValue(.radicalKernAfterDegree)
    }
    
    public var radicalDegreeBottomRaisePercent: Int32 {
        getPercent(.radicalDegreeBottomRaisePercent)
    }
}

/// The math constant index
public enum MathConstant : Int, Comparable {
    case scriptPercentScaleDown = 0
    case scriptScriptPercentScaleDown = 1
    case delimitedSubFormulaMinHeight = 2
    case displayOperatorMinHeight = 3
    case mathLeading = 4
    case axisHeight = 5
    case accentBaseHeight = 6
    case flattenedAccentBaseHeight = 7
    case subscriptShiftDown = 8
    case subscriptTopMax = 9
    case subscriptBaselineDropMin = 10
    case superscriptShiftUp = 11
    case superscriptShiftUpCramped = 12
    case superscriptBottomMin = 13
    case superscriptBaselineDropMax = 14
    case subSuperscriptGapMin = 15
    case superscriptBottomMaxWithSubscript = 16
    case spaceAfterScript = 17
    case upperLimitGapMin = 18
    case upperLimitBaselineRiseMin = 19
    case lowerLimitGapMin = 20
    case lowerLimitBaselineDropMin = 21
    case stackTopShiftUp = 22
    case stackTopDisplayStyleShiftUp = 23
    case stackBottomShiftDown = 24
    case stackBottomDisplayStyleShiftDown = 25
    case stackGapMin = 26
    case stackDisplayStyleGapMin = 27
    case stretchStackTopShiftUp = 28
    case stretchStackBottomShiftDown = 29
    case stretchStackGapAboveMin = 30
    case stretchStackGapBelowMin = 31
    case fractionNumeratorShiftUp = 32
    case fractionNumeratorDisplayStyleShiftUp = 33
    case fractionDenominatorShiftDown = 34
    case fractionDenominatorDisplayStyleShiftDown = 35
    case fractionNumeratorGapMin = 36
    case fractionNumDisplayStyleGapMin = 37
    case fractionRuleThickness = 38
    case fractionDenominatorGapMin = 39
    case fractionDenomDisplayStyleGapMin = 40
    case skewedFractionHorizontalGap = 41
    case skewedFractionVerticalGap = 42
    case overbarVerticalGap = 43
    case overbarRuleThickness = 44
    case overbarExtraAscender = 45
    case underbarVerticalGap = 46
    case underbarRuleThickness = 47
    case underbarExtraDescender = 48
    case radicalVerticalGap = 49
    case radicalDisplayStyleVerticalGap = 50
    case radicalRuleThickness = 51
    case radicalExtraAscender = 52
    case radicalKernBeforeDegree = 53
    case radicalKernAfterDegree = 54
    case radicalDegreeBottomRaisePercent = 55
    
    func getByteOffset() -> Int {
        let mathLeading = MathConstant.mathLeading.rawValue
        if (rawValue < mathLeading) {
            return rawValue * 2
        }
        else {
            return mathLeading * 2 + (rawValue - mathLeading) * 4
        }
    }
    
    public static func < (lhs: MathConstant, rhs: MathConstant) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
