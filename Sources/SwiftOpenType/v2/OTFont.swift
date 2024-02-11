import CoreText

/// A wrapper of CTFont, extended with some contexts
public class OTFont {
    let font: CTFont
    let ppem: UInt32 /// pixels-per-em
    let sizePerUnit: CGFloat
    
    convenience init(font: CTFont) {
        self.init(font: font, ppem: 0)
    }
    
    init(font: CTFont, ppem: UInt32) {
        self.font = font
        self.ppem = ppem
        self.sizePerUnit = CTFontGetSize(font) / CGFloat(CTFontGetUnitsPerEm(font))
    }
    
    public var unitsPerEm: UInt32 {
        CTFontGetUnitsPerEm(font)
    }
    
    func getContextData() -> ContextData {
        ContextData(ppem: self.ppem, unitsPerEm: self.unitsPerEm)
    }
    
    public var mathTable: MathTableV2? {
        self._mathTable
    }
    
    private lazy var _mathTable : MathTableV2? = {
        if let data = self.font.getMathTableData() {
            let table = MathTableV2(base: CFDataGetBytePtr(data),
                                    context: self.getContextData())
            if table.majorVersion() == 1 {
                return table
            }
        }
        return nil
    }()
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

extension OTFont {
    public func getGlyphItalicsCorrection(glyph: UInt16) -> CGFloat {
        let value = self.mathTable?.mathGlyphInfoTable?.mathItalicsCorrectionInfoTable?.getItalicsCorrection(glyphID: glyph)
        if let value = value {
            return CGFloat(value) * self.sizePerUnit
        }
        return 0
    }
}

internal class ContextData {
    let ppem: UInt32
    let unitsPerEm: UInt32
    
    init(ppem: UInt32, unitsPerEm: UInt32) {
        self.ppem = ppem
        self.unitsPerEm = unitsPerEm
    }
}

/// int16 that describes a quantity in font design units.
public typealias FWORD = Int16
/// uint16 that describes a quantity in font design units.
public typealias UFWORD = UInt16
/// Short offset to a table, same as uint16, NULL offset = 0x0000
public typealias Offset16 = UInt16

/// Read UInt16 at ptr.
@inline(__always)
func readUInt16(_ ptr: UnsafePointer<UInt8>) -> UInt16 {
    // All OpenType fonts use Motorola-style byte ordering (Big Endian).
    ptr.withMemoryRebound(to: UInt16.self, capacity: 1) {
        $0.pointee.byteSwapped
    }
}

/// Read Int16 at ptr.
@inline(__always)
func readInt16(_ ptr: UnsafePointer<UInt8>) -> Int16 {
    // All OpenType fonts use Motorola-style byte ordering (Big Endian).
    ptr.withMemoryRebound(to: Int16.self, capacity: 1) {
        $0.pointee.byteSwapped
    }
}

@inline(__always)
func readFWORD(_ ptr: UnsafePointer<UInt8>) -> FWORD {
    readInt16(ptr)
}

@inline(__always)
func readUFWORD(_ ptr: UnsafePointer<UInt8>) -> UFWORD {
    readUInt16(ptr)
}

@inline(__always)
func readOffset16(_ ptr: UnsafePointer<UInt8>) -> Offset16 {
    readUInt16(ptr)
}
