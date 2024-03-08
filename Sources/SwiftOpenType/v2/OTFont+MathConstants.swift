import CoreFoundation

public extension OTFont {
    /// Returns the requested constant or zero
    func getMathConstant(_ index: MathConstant) -> CGFloat {
        if let table = mathTable?.mathConstantsTable {
            if index <= MathConstant.scriptScriptPercentScaleDown {
                return CGFloat(table.getPercent(index)) / 100
            } else if index <= MathConstant.displayOperatorMinHeight {
                return CGFloat(table.getMinHeight(index)) * sizePerUnit
            } else if index <= MathConstant.radicalKernAfterDegree {
                return CGFloat(table.getMathValue(index)) * sizePerUnit
            } else if index == MathConstant.radicalDegreeBottomRaisePercent {
                return CGFloat(table.getPercent(index)) / 100
            }
            fatalError("Unreachable")
        } else {
            return 0
        }
    }

    func scriptPercentScaleDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.scriptPercentScaleDown() ?? 0) / 100
    }

    func scriptScriptPercentScaleDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.scriptScriptPercentScaleDown() ?? 0) / 100
    }

    func delimitedSubFormulaMinHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.delimitedSubFormulaMinHeight() ?? 0) * sizePerUnit
    }

    func displayOperatorMinHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.displayOperatorMinHeight() ?? 0) * sizePerUnit
    }

    func mathLeading() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.mathLeading() ?? 0) * sizePerUnit
    }

    func axisHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.axisHeight() ?? 0) * sizePerUnit
    }

    func accentBaseHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.accentBaseHeight() ?? 0) * sizePerUnit
    }

    func flattenedAccentBaseHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.flattenedAccentBaseHeight() ?? 0) * sizePerUnit
    }

    func subscriptShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subscriptShiftDown() ?? 0) * sizePerUnit
    }

    func subscriptTopMax() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subscriptTopMax() ?? 0) * sizePerUnit
    }

    func subscriptBaselineDropMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subscriptBaselineDropMin() ?? 0) * sizePerUnit
    }

    func superscriptShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptShiftUp() ?? 0) * sizePerUnit
    }

    func superscriptShiftUpCramped() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptShiftUpCramped() ?? 0) * sizePerUnit
    }

    func superscriptBottomMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptBottomMin() ?? 0) * sizePerUnit
    }

    func superscriptBaselineDropMax() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptBaselineDropMax() ?? 0) * sizePerUnit
    }

    func subSuperscriptGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subSuperscriptGapMin() ?? 0) * sizePerUnit
    }

    func superscriptBottomMaxWithSubscript() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptBottomMaxWithSubscript() ?? 0) * sizePerUnit
    }

    func spaceAfterScript() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.spaceAfterScript() ?? 0) * sizePerUnit
    }

    func upperLimitGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.upperLimitGapMin() ?? 0) * sizePerUnit
    }

    func upperLimitBaselineRiseMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.upperLimitBaselineRiseMin() ?? 0) * sizePerUnit
    }

    func lowerLimitGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.lowerLimitGapMin() ?? 0) * sizePerUnit
    }

    func lowerLimitBaselineDropMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.lowerLimitBaselineDropMin() ?? 0) * sizePerUnit
    }

    func stackTopShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackTopShiftUp() ?? 0) * sizePerUnit
    }

    func stackTopDisplayStyleShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackTopDisplayStyleShiftUp() ?? 0) * sizePerUnit
    }

    func stackBottomShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackBottomShiftDown() ?? 0) * sizePerUnit
    }

    func stackBottomDisplayStyleShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackBottomDisplayStyleShiftDown() ?? 0) * sizePerUnit
    }

    func stackGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackGapMin() ?? 0) * sizePerUnit
    }

    func stackDisplayStyleGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackDisplayStyleGapMin() ?? 0) * sizePerUnit
    }

    func stretchStackTopShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackTopShiftUp() ?? 0) * sizePerUnit
    }

    func stretchStackBottomShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackBottomShiftDown() ?? 0) * sizePerUnit
    }

    func stretchStackGapAboveMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackGapAboveMin() ?? 0) * sizePerUnit
    }

    func stretchStackGapBelowMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackGapBelowMin() ?? 0) * sizePerUnit
    }

    func fractionNumeratorShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumeratorShiftUp() ?? 0) * sizePerUnit
    }

    func fractionNumeratorDisplayStyleShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumeratorDisplayStyleShiftUp() ?? 0) * sizePerUnit
    }

    func fractionDenominatorShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenominatorShiftDown() ?? 0) * sizePerUnit
    }

    func fractionDenominatorDisplayStyleShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenominatorDisplayStyleShiftDown() ?? 0) * sizePerUnit
    }

    func fractionNumeratorGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumeratorGapMin() ?? 0) * sizePerUnit
    }

    func fractionNumDisplayStyleGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumDisplayStyleGapMin() ?? 0) * sizePerUnit
    }

    func fractionRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionRuleThickness() ?? 0) * sizePerUnit
    }

    func fractionDenominatorGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenominatorGapMin() ?? 0) * sizePerUnit
    }

    func fractionDenomDisplayStyleGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenomDisplayStyleGapMin() ?? 0) * sizePerUnit
    }

    func skewedFractionHorizontalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.skewedFractionHorizontalGap() ?? 0) * sizePerUnit
    }

    func skewedFractionVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.skewedFractionVerticalGap() ?? 0) * sizePerUnit
    }

    func overbarVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.overbarVerticalGap() ?? 0) * sizePerUnit
    }

    func overbarRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.overbarRuleThickness() ?? 0) * sizePerUnit
    }

    func overbarExtraAscender() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.overbarExtraAscender() ?? 0) * sizePerUnit
    }

    func underbarVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.underbarVerticalGap() ?? 0) * sizePerUnit
    }

    func underbarRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.underbarRuleThickness() ?? 0) * sizePerUnit
    }

    func underbarExtraDescender() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.underbarExtraDescender() ?? 0) * sizePerUnit
    }

    func radicalVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalVerticalGap() ?? 0) * sizePerUnit
    }

    func radicalDisplayStyleVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalDisplayStyleVerticalGap() ?? 0) * sizePerUnit
    }

    func radicalRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalRuleThickness() ?? 0) * sizePerUnit
    }

    func radicalExtraAscender() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalExtraAscender() ?? 0) * sizePerUnit
    }

    func radicalKernBeforeDegree() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalKernBeforeDegree() ?? 0) * sizePerUnit
    }

    func radicalKernAfterDegree() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalKernAfterDegree() ?? 0) * sizePerUnit
    }

    func radicalDegreeBottomRaisePercent() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalDegreeBottomRaisePercent() ?? 0) / 100
    }
}
