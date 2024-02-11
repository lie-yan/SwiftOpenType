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
    let context: ContextData
    var values: [Int32?]
    
    init(base: UnsafePointer<UInt8>, context: ContextData) {
        self.base = base
        self.context = context
        self.values = [Int32?](repeating: nil, count: MathConstant.allCases.count)
    }

    /// Return the math constant specified by the argument in design units.
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
        
        fatalError("Unreachable")
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
    
    // MARK: - helper functions
    
    /// for {scriptPercentScaleDown, scriptScriptPercentScaleDown, radicalDegreeBottomRaisePercent}
    func getPercent(_ index: MathConstant) -> Int32 {
        let i = index.rawValue
        if values[i] == nil {
            values[i] = fetchPercent(index)
        }
        return values[i]!
    }
    private func fetchPercent(_ index: MathConstant) -> Int32 {
        let offset = index.getOffset()
        let value = readInt16(base + offset)
        return Int32(value)
    }
    
    /// for {delimitedSubFormulaMinHeight, displayOperatorMinHeight}
    func getMinHeight(_ index: MathConstant) -> Int32 {
        let i = index.rawValue
        if values[i] == nil {
            values[i] = fetchMinHeight(index)
        }
        return values[i]!
    }
    private func fetchMinHeight(_ index: MathConstant) -> Int32 {
        let offset = index.getOffset()
        let value = readUFWORD(base + offset)
        return Int32(value)
    }
    
    /// for the remaining
    func getMathValue(_ index: MathConstant) -> Int32 {
        let i = index.rawValue
        if values[i] == nil {
            values[i] = fetchMathValue(index)
        }
        return values[i]!
    }
    private func fetchMathValue(_ index: MathConstant) -> Int32 {
        let offset = index.getOffset()
        let mathValueRecord = MathValueRecord.read(ptr: base + offset)
        return MathValueRecord.eval(parentBase: self.base, 
                                    mathValueRecord: mathValueRecord,
                                    context: context)
    }
}


extension OTFont {
    public func getMathConstant(_ index: MathConstant) -> CGFloat {
        let table = self.mathTable!.mathConstantsTable!
        
        if (index <= MathConstant.scriptScriptPercentScaleDown) {
            return CGFloat(table.getPercent(index)) / 100.0
        }
        else if (index <= MathConstant.displayOperatorMinHeight) {
            return CGFloat(table.getMinHeight(index)) * self.sizePerUnit
        }
        else if (index <= MathConstant.radicalKernAfterDegree) {
            return CGFloat(table.getMathValue(index)) * self.sizePerUnit
        }
        else if (index == MathConstant.radicalDegreeBottomRaisePercent) {
            return CGFloat(table.getPercent(index)) / 100.0
        }
        
        fatalError("Unreachable")
    }
    
    public func scriptPercentScaleDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.scriptPercentScaleDown) / 100.0
    }
    
    public func scriptScriptPercentScaleDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.scriptScriptPercentScaleDown) / 100.0
    }
    
    public func delimitedSubFormulaMinHeight() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.delimitedSubFormulaMinHeight) * self.sizePerUnit
    }
    
    public func displayOperatorMinHeight() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.displayOperatorMinHeight) * self.sizePerUnit
    }
    
    public func mathLeading() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.mathLeading) * self.sizePerUnit
    }
    
    public func axisHeight() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.axisHeight) * self.sizePerUnit
    }
    
    public func accentBaseHeight() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.accentBaseHeight) * self.sizePerUnit
    }
    
    public func flattenedAccentBaseHeight() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.flattenedAccentBaseHeight) * self.sizePerUnit
    }
    
    public func subscriptShiftDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.subscriptShiftDown) * self.sizePerUnit
    }
    
    public func subscriptTopMax() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.subscriptTopMax) * self.sizePerUnit
    }
    
    public func subscriptBaselineDropMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.subscriptBaselineDropMin) * self.sizePerUnit
    }
    
    public func superscriptShiftUp() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.superscriptShiftUp) * self.sizePerUnit
    }
    
    public func superscriptShiftUpCramped() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.superscriptShiftUpCramped) * self.sizePerUnit
    }
    
    public func superscriptBottomMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.superscriptBottomMin) * self.sizePerUnit
    }
    
    public func superscriptBaselineDropMax() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.superscriptBaselineDropMax) * self.sizePerUnit
    }
    
    public func subSuperscriptGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.subSuperscriptGapMin) * self.sizePerUnit
    }
    
    public func superscriptBottomMaxWithSubscript() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.superscriptBottomMaxWithSubscript) * self.sizePerUnit
    }
    
    public func spaceAfterScript() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.spaceAfterScript) * self.sizePerUnit
    }
    
    public func upperLimitGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.upperLimitGapMin) * self.sizePerUnit
    }
    
    public func upperLimitBaselineRiseMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.upperLimitBaselineRiseMin) * self.sizePerUnit
    }
    
    public func lowerLimitGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.lowerLimitGapMin) * self.sizePerUnit
    }
    
    public func lowerLimitBaselineDropMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.lowerLimitBaselineDropMin) * self.sizePerUnit
    }
    
    public func stackTopShiftUp() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stackTopShiftUp) * self.sizePerUnit
    }
    
    public func stackTopDisplayStyleShiftUp() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stackTopDisplayStyleShiftUp) * self.sizePerUnit
    }
    
    public func stackBottomShiftDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stackBottomShiftDown) * self.sizePerUnit
    }
    
    public func stackBottomDisplayStyleShiftDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stackBottomDisplayStyleShiftDown) * self.sizePerUnit
    }
    
    public func stackGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stackGapMin) * self.sizePerUnit
    }
    
    public func stackDisplayStyleGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stackDisplayStyleGapMin) * self.sizePerUnit
    }
    
    public func stretchStackTopShiftUp() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stretchStackTopShiftUp) * self.sizePerUnit
    }
    
    public func stretchStackBottomShiftDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stretchStackBottomShiftDown) * self.sizePerUnit
    }
    
    public func stretchStackGapAboveMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stretchStackGapAboveMin) * self.sizePerUnit
    }
    
    public func stretchStackGapBelowMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.stretchStackGapBelowMin) * self.sizePerUnit
    }
    
    public func fractionNumeratorShiftUp() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionNumeratorShiftUp) * self.sizePerUnit
    }
    
    public func fractionNumeratorDisplayStyleShiftUp() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionNumeratorDisplayStyleShiftUp) * self.sizePerUnit
    }
    
    public func fractionDenominatorShiftDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionDenominatorShiftDown) * self.sizePerUnit
    }
    
    public func fractionDenominatorDisplayStyleShiftDown() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionDenominatorDisplayStyleShiftDown) * self.sizePerUnit
    }
    
    public func fractionNumeratorGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionNumeratorGapMin) * self.sizePerUnit
    }
    
    public func fractionNumDisplayStyleGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionNumDisplayStyleGapMin) * self.sizePerUnit
    }
    
    public func fractionRuleThickness() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionRuleThickness) * self.sizePerUnit
    }
    
    public func fractionDenominatorGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionDenominatorGapMin) * self.sizePerUnit
    }
    
    public func fractionDenomDisplayStyleGapMin() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.fractionDenomDisplayStyleGapMin) * self.sizePerUnit
    }
    
    public func skewedFractionHorizontalGap() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.skewedFractionHorizontalGap) * self.sizePerUnit
    }
    
    public func skewedFractionVerticalGap() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.skewedFractionVerticalGap) * self.sizePerUnit
    }
    
    public func overbarVerticalGap() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.overbarVerticalGap) * self.sizePerUnit
    }
    
    public func overbarRuleThickness() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.overbarRuleThickness) * self.sizePerUnit
    }
    
    public func overbarExtraAscender() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.overbarExtraAscender) * self.sizePerUnit
    }
    
    public func underbarVerticalGap() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.underbarVerticalGap) * self.sizePerUnit
    }
    
    public func underbarRuleThickness() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.underbarRuleThickness) * self.sizePerUnit
    }
    
    public func underbarExtraDescender() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.underbarExtraDescender) * self.sizePerUnit
    }
    
    public func radicalVerticalGap() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.radicalVerticalGap) * self.sizePerUnit
    }
    
    public func radicalDisplayStyleVerticalGap() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.radicalDisplayStyleVerticalGap) * self.sizePerUnit
    }
    
    public func radicalRuleThickness() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.radicalRuleThickness) * self.sizePerUnit
    }
    
    public func radicalExtraAscender() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.radicalExtraAscender) * self.sizePerUnit
    }
    
    public func radicalKernBeforeDegree() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.radicalKernBeforeDegree) * self.sizePerUnit
    }
    
    public func radicalKernAfterDegree() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.radicalKernAfterDegree) * self.sizePerUnit
    }
    
    public func radicalDegreeBottomRaisePercent() -> CGFloat {
        CGFloat(self.mathTable!.mathConstantsTable!.radicalDegreeBottomRaisePercent) / 100.0
    }
}

/// The math constant index
public enum MathConstant : Int, Comparable, CaseIterable {
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
    
    // Return the byte offset of math constant
    func getOffset() -> Int {
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
