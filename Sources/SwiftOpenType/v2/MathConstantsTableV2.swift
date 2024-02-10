import CoreFoundation

/**
 The MathConstants table
 
 For more details, refer to [MathConstants Table](https://docs.microsoft.com/en-us/typography/opentype/spec/math#mathconstants-table)
 of the OpenType specification.
 
 Below is the correspondence between OpenType parameters and TeX parameters.
 For an illustrated exposition, refer to _Ulrik Vieth (2009). OpenType math illuminated._
 
 OpenType parameter                       | TeX parameter
 -----------------------------------------|----------------------------------
 scriptPercentScaleDown                   | e.g. 70-80 %
 scriptScriptPercentScaleDown             | e.g. 50-60 %
 (no correspondence)                      | σ20 (e.g. 20-24 pt)
 delimitedSubFormulaMinHeight             | σ21 (e.g. 10-12 pt)
 displayOperatorMinHeight                 | ?? (e.g. 12-15 pt)
 mathLeading                              | unused
 axisHeight                               | σ22 (axis height)
 accentBaseHeight                         | σ5 (x-height)
 flattenedAccentBaseHeight                | ?? (capital height)
 subscriptShiftDown                       | σ16, σ17
 subscriptTopMax                          | (= 4/5 σ5)
 subscriptBaselineDropMin                 | σ19
 superscriptShiftUp                       | σ13, σ14
 superscriptShiftUpCramped                | σ15
 superscriptBottomMin                     | (= 1/4 σ5)
 superscriptBaselineDropMax               | σ18
 subSuperscriptGapMin                     | (= 4 ξ8)
 superscriptBottomMaxWithSubscript        | (= 4/5 σ5)
 spaceAfterScript                         | \scriptspace
 upperLimitGapMin                         | ξ9
 upperLimitBaselineRiseMin                | ξ11
 lowerLimitGapMin                         | ξ10
 lowerLimitBaselineDropMin                | ξ12
 (no correspondence)                      | ξ13
 stackTopShiftUp                          | σ10
 stackTopDisplayStyleShiftUp              | σ8
 stackBottomShiftDown                     | σ12
 stackBottomDisplayStyleShiftDown         | σ11
 stackGapMin                              | (= 3 ξ8)
 stackDisplayStyleGapMin                  | (= 7 ξ8)
 stretchStackTopShiftUp                   | ξ11
 stretchStackBottomShiftDown              | ξ12
 stretchStackGapAboveMin                  | ξ9
 stretchStackGapBelowMin                  | ξ10
 fractionNumeratorShiftUp                 | σ9
 fractionNumeratorDisplayStyleShiftUp     | σ8
 fractionDenominatorShiftDown             | σ12
 fractionDenominatorDisplayStyleShiftDown | σ11
 fractionNumeratorGapMin                  | (= ξ8)
 fractionNumDisplayStyleGapMin            | (= 3 ξ8)
 fractionRuleThickness                    | (= ξ8)
 fractionDenominatorGapMin                | (= ξ8)
 fractionDenomDisplayStyleGapMin          | (= 3 ξ8)
 skewedFractionHorizontalGap              |
 skewedFractionVerticalGap                |
 overbarVerticalGap                       | (= 3 ξ8)
 overbarRuleThickness                     | (= ξ8)
 overbarExtraAscender                     | (= ξ8)
 underbarVerticalGap                      | (= 3 ξ8)
 underbarRuleThickness                    | (= ξ8)
 underbarExtraDescender                   | (= ξ8)
 radicalVerticalGap                       | (= ξ8 + 1/4 ξ8)
 radicalDisplayStyleVerticalGap           | (= ξ8 + 1/4 σ5)
 radicalRuleThickness                     | (= ξ8)
 radicalExtraAscender                     | (= ξ8)
 radicalKernBeforeDegree                  | e.g. 5/18 em
 radicalKernAfterDegree                   | e.g. 10/18 em
 radicalDegreeBottomRaisePercent          | e.g. 60 %
 
 Parameter                                | Notation
 -----------------------------------------|----------------------------------
 x_height                                 | σ5
 quad                                     | σ6
 sup1                                     | σ13
 sup2                                     | σ14
 sup3                                     | σ15
 sub1                                     | σ16
 sub2                                     | σ17
 sup_drop                                 | σ18
 sub_drop                                 | σ19
 axis_height                              | σ22
 default_rule_thickness                   | ξ8
 math unit                                | σ6 / 18
 math quad                                | σ6
 thin space                               | normally 1/6 σ6  (= 3mu)
 medium space                             | normally 2/9 σ6  (= 4mu)
 thick space                              | normally 5/18 σ6 (= 5mu)
 */
public class MathConstantsTableV2 {
    let base: UnsafePointer<UInt8>

    init(base: UnsafePointer<UInt8>) {
        self.base = base
    }
    
    convenience init(parentBase: UnsafePointer<UInt8>, offset: Offset16) {
        self.init(base: parentBase + Int(offset))
    }
    
    /// for {scriptPercentScaleDown, scriptScriptPercentScaleDown, radicalDegreeBottomRaisePercent}
    private func getPercent(_ index: MathConstant) -> Int32 {
        let offset = index.getOffset()
        let value = readInt16(base + offset)
        return Int32(value)
    }
    
    /// for {delimitedSubFormulaMinHeight, displayOperatorMinHeight}
    private func getMinHeight(_ index: MathConstant) -> Int32 {
        let offset = index.getOffset()
        let value = readUFWORD(base + offset)
        return Int32(value)
    }
    
    /// for the remaining
    private func getMathValue(_ index: MathConstant) -> Int32 {
        let offset = index.getOffset()
        let mathValueRecord = MathValueRecord.read(ptr: base + offset)
        return MathValueRecord.eval(parentBase: self.base, mathValueRecord: mathValueRecord)
    }
}
