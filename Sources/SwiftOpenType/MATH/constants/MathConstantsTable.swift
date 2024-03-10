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
class MathConstantsTable {
    let base: UnsafePointer<UInt8>
    let context: ContextData
    private lazy var values: [Int32] = computeMathConstantArray()

    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
    }

    /// Returns in design units the math constant specified by the argument.
    func getMathConstant(_ index: MathConstant) -> Int32 {
        if index <= MathConstant.scriptScriptPercentScaleDown {
            return getPercent(index)
        } else if index <= MathConstant.displayOperatorMinHeight {
            return getMinHeight(index)
        } else if index <= MathConstant.radicalKernAfterDegree {
            return getMathValue(index)
        } else if index == MathConstant.radicalDegreeBottomRaisePercent {
            return getPercent(index)
        }
        fatalError("Unreachable")
    }

    private func fetchMathConstant(_ index: MathConstant) -> Int32 {
        if index <= MathConstant.scriptScriptPercentScaleDown {
            return fetchPercent(index)
        } else if index <= MathConstant.displayOperatorMinHeight {
            return fetchMinHeight(index)
        } else if index <= MathConstant.radicalKernAfterDegree {
            return fetchMathValue(index)
        } else if index == MathConstant.radicalDegreeBottomRaisePercent {
            return fetchPercent(index)
        }
        fatalError("Unreachable")
    }

    private func computeMathConstantArray() -> [Int32] {
        [Int32].init(unsafeUninitializedCapacity: MathConstant.allCases.count,
                     initializingWith: {
                         buffer, initializedCount in
                         for i in MathConstant.allCases {
                             buffer[i.rawValue] = self.fetchMathConstant(i)
                         }
                         initializedCount = MathConstant.allCases.count
                     })
    }

    func scriptPercentScaleDown() -> Int32 {
        getPercent(.scriptPercentScaleDown)
    }

    func scriptScriptPercentScaleDown() -> Int32 {
        getPercent(.scriptScriptPercentScaleDown)
    }

    func delimitedSubFormulaMinHeight() -> Int32 {
        getMinHeight(.delimitedSubFormulaMinHeight)
    }

    func displayOperatorMinHeight() -> Int32 {
        getMinHeight(.displayOperatorMinHeight)
    }

    func mathLeading() -> Int32 {
        getMathValue(.mathLeading)
    }

    func axisHeight() -> Int32 {
        getMathValue(.axisHeight)
    }

    func accentBaseHeight() -> Int32 {
        getMathValue(.accentBaseHeight)
    }

    func flattenedAccentBaseHeight() -> Int32 {
        getMathValue(.flattenedAccentBaseHeight)
    }

    func subscriptShiftDown() -> Int32 {
        getMathValue(.subscriptShiftDown)
    }

    func subscriptTopMax() -> Int32 {
        getMathValue(.subscriptTopMax)
    }

    func subscriptBaselineDropMin() -> Int32 {
        getMathValue(.subscriptBaselineDropMin)
    }

    func superscriptShiftUp() -> Int32 {
        getMathValue(.superscriptShiftUp)
    }

    func superscriptShiftUpCramped() -> Int32 {
        getMathValue(.superscriptShiftUpCramped)
    }

    func superscriptBottomMin() -> Int32 {
        getMathValue(.superscriptBottomMin)
    }

    func superscriptBaselineDropMax() -> Int32 {
        getMathValue(.superscriptBaselineDropMax)
    }

    func subSuperscriptGapMin() -> Int32 {
        getMathValue(.subSuperscriptGapMin)
    }

    func superscriptBottomMaxWithSubscript() -> Int32 {
        getMathValue(.superscriptBottomMaxWithSubscript)
    }

    func spaceAfterScript() -> Int32 {
        getMathValue(.spaceAfterScript)
    }

    func upperLimitGapMin() -> Int32 {
        getMathValue(.upperLimitGapMin)
    }

    func upperLimitBaselineRiseMin() -> Int32 {
        getMathValue(.upperLimitBaselineRiseMin)
    }

    func lowerLimitGapMin() -> Int32 {
        getMathValue(.lowerLimitGapMin)
    }

    func lowerLimitBaselineDropMin() -> Int32 {
        getMathValue(.lowerLimitBaselineDropMin)
    }

    func stackTopShiftUp() -> Int32 {
        getMathValue(.stackTopShiftUp)
    }

    func stackTopDisplayStyleShiftUp() -> Int32 {
        getMathValue(.stackTopDisplayStyleShiftUp)
    }

    func stackBottomShiftDown() -> Int32 {
        getMathValue(.stackBottomShiftDown)
    }

    func stackBottomDisplayStyleShiftDown() -> Int32 {
        getMathValue(.stackBottomDisplayStyleShiftDown)
    }

    func stackGapMin() -> Int32 {
        getMathValue(.stackGapMin)
    }

    func stackDisplayStyleGapMin() -> Int32 {
        getMathValue(.stackDisplayStyleGapMin)
    }

    func stretchStackTopShiftUp() -> Int32 {
        getMathValue(.stretchStackTopShiftUp)
    }

    func stretchStackBottomShiftDown() -> Int32 {
        getMathValue(.stretchStackBottomShiftDown)
    }

    func stretchStackGapAboveMin() -> Int32 {
        getMathValue(.stretchStackGapAboveMin)
    }

    func stretchStackGapBelowMin() -> Int32 {
        getMathValue(.stretchStackGapBelowMin)
    }

    func fractionNumeratorShiftUp() -> Int32 {
        getMathValue(.fractionNumeratorShiftUp)
    }

    func fractionNumeratorDisplayStyleShiftUp() -> Int32 {
        getMathValue(.fractionNumeratorDisplayStyleShiftUp)
    }

    func fractionDenominatorShiftDown() -> Int32 {
        getMathValue(.fractionDenominatorShiftDown)
    }

    func fractionDenominatorDisplayStyleShiftDown() -> Int32 {
        getMathValue(.fractionDenominatorDisplayStyleShiftDown)
    }

    func fractionNumeratorGapMin() -> Int32 {
        getMathValue(.fractionNumeratorGapMin)
    }

    func fractionNumDisplayStyleGapMin() -> Int32 {
        getMathValue(.fractionNumDisplayStyleGapMin)
    }

    func fractionRuleThickness() -> Int32 {
        getMathValue(.fractionRuleThickness)
    }

    func fractionDenominatorGapMin() -> Int32 {
        getMathValue(.fractionDenominatorGapMin)
    }

    func fractionDenomDisplayStyleGapMin() -> Int32 {
        getMathValue(.fractionDenomDisplayStyleGapMin)
    }

    func skewedFractionHorizontalGap() -> Int32 {
        getMathValue(.skewedFractionHorizontalGap)
    }

    func skewedFractionVerticalGap() -> Int32 {
        getMathValue(.skewedFractionVerticalGap)
    }

    func overbarVerticalGap() -> Int32 {
        getMathValue(.overbarVerticalGap)
    }

    func overbarRuleThickness() -> Int32 {
        getMathValue(.overbarRuleThickness)
    }

    func overbarExtraAscender() -> Int32 {
        getMathValue(.overbarExtraAscender)
    }

    func underbarVerticalGap() -> Int32 {
        getMathValue(.underbarVerticalGap)
    }

    func underbarRuleThickness() -> Int32 {
        getMathValue(.underbarRuleThickness)
    }

    func underbarExtraDescender() -> Int32 {
        getMathValue(.underbarExtraDescender)
    }

    func radicalVerticalGap() -> Int32 {
        getMathValue(.radicalVerticalGap)
    }

    func radicalDisplayStyleVerticalGap() -> Int32 {
        getMathValue(.radicalDisplayStyleVerticalGap)
    }

    func radicalRuleThickness() -> Int32 {
        getMathValue(.radicalRuleThickness)
    }

    func radicalExtraAscender() -> Int32 {
        getMathValue(.radicalExtraAscender)
    }

    func radicalKernBeforeDegree() -> Int32 {
        getMathValue(.radicalKernBeforeDegree)
    }

    func radicalKernAfterDegree() -> Int32 {
        getMathValue(.radicalKernAfterDegree)
    }

    func radicalDegreeBottomRaisePercent() -> Int32 {
        getPercent(.radicalDegreeBottomRaisePercent)
    }

    // MARK: - helper functions

    /// for {scriptPercentScaleDown, scriptScriptPercentScaleDown, radicalDegreeBottomRaisePercent}
    func getPercent(_ index: MathConstant) -> Int32 {
        values[index.rawValue]
    }

    private func fetchPercent(_ index: MathConstant) -> Int32 {
        Int32(readInt16(base + index.getOffset()))
    }

    /// for {delimitedSubFormulaMinHeight, displayOperatorMinHeight}
    func getMinHeight(_ index: MathConstant) -> Int32 {
        values[index.rawValue]
    }

    private func fetchMinHeight(_ index: MathConstant) -> Int32 {
        Int32(readUFWORD(base + index.getOffset()))
    }

    /// for the remaining
    func getMathValue(_ index: MathConstant) -> Int32 {
        values[index.rawValue]
    }

    private func fetchMathValue(_ index: MathConstant) -> Int32 {
        let record = MathValueRecord.read(base + index.getOffset())
        return MathValueRecord.eval(base, record, context)
    }
}

/// The math constant index
public enum MathConstant: Int, Comparable, CaseIterable {
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

    // Returns the byte offset of math constant
    func getOffset() -> Int {
        let mathLeading = MathConstant.mathLeading.rawValue
        if rawValue < mathLeading {
            return rawValue * 2
        } else {
            return mathLeading * 2 + (rawValue - mathLeading) * MathValueRecord.byteSize
        }
    }

    public static func < (lhs: MathConstant, rhs: MathConstant) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
