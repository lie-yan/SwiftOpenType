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
    /// Return the requested constant or zero
    public func getMathConstant(_ index: MathConstant) -> CGFloat {
        if let table = self.mathTable?.mathConstantsTable {
            if (index <= MathConstant.scriptScriptPercentScaleDown) {
                return CGFloat(table.getPercent(index)) / 100
            }
            else if (index <= MathConstant.displayOperatorMinHeight) {
                return CGFloat(table.getMinHeight(index)) * self.sizePerUnit
            }
            else if (index <= MathConstant.radicalKernAfterDegree) {
                return CGFloat(table.getMathValue(index)) * self.sizePerUnit
            }
            else if (index == MathConstant.radicalDegreeBottomRaisePercent) {
                return CGFloat(table.getPercent(index)) / 100
            }
            fatalError("Unreachable")
        }
        else {
            return 0
        }
    }
    
    public func scriptPercentScaleDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.scriptPercentScaleDown {
            return CGFloat(value) / 100
        }
        else {
            return 0
        }
    }
    
    public func scriptScriptPercentScaleDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.scriptScriptPercentScaleDown {
            return CGFloat(value) / 100
        }
        else {
            return 0
        }
    }
    
    public func delimitedSubFormulaMinHeight() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.delimitedSubFormulaMinHeight {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func displayOperatorMinHeight() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.displayOperatorMinHeight {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func mathLeading() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.mathLeading {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func axisHeight() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.axisHeight {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func accentBaseHeight() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.accentBaseHeight {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func flattenedAccentBaseHeight() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.flattenedAccentBaseHeight {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func subscriptShiftDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.subscriptShiftDown {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func subscriptTopMax() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.subscriptTopMax {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func subscriptBaselineDropMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.subscriptBaselineDropMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func superscriptShiftUp() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.superscriptShiftUp {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func superscriptShiftUpCramped() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.superscriptShiftUpCramped {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func superscriptBottomMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.superscriptBottomMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func superscriptBaselineDropMax() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.superscriptBaselineDropMax {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func subSuperscriptGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.subSuperscriptGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func superscriptBottomMaxWithSubscript() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.superscriptBottomMaxWithSubscript {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func spaceAfterScript() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.spaceAfterScript {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func upperLimitGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.upperLimitGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func upperLimitBaselineRiseMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.upperLimitBaselineRiseMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func lowerLimitGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.lowerLimitGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func lowerLimitBaselineDropMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.lowerLimitBaselineDropMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stackTopShiftUp() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stackTopShiftUp {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stackTopDisplayStyleShiftUp() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stackTopDisplayStyleShiftUp {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stackBottomShiftDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stackBottomShiftDown {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stackBottomDisplayStyleShiftDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stackBottomDisplayStyleShiftDown {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stackGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stackGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stackDisplayStyleGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stackDisplayStyleGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stretchStackTopShiftUp() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stretchStackTopShiftUp {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stretchStackBottomShiftDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stretchStackBottomShiftDown {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stretchStackGapAboveMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stretchStackGapAboveMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func stretchStackGapBelowMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.stretchStackGapBelowMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionNumeratorShiftUp() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionNumeratorShiftUp {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionNumeratorDisplayStyleShiftUp() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionNumeratorDisplayStyleShiftUp {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionDenominatorShiftDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionDenominatorShiftDown {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionDenominatorDisplayStyleShiftDown() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionDenominatorDisplayStyleShiftDown {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionNumeratorGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionNumeratorGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionNumDisplayStyleGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionNumDisplayStyleGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionRuleThickness() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionRuleThickness {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionDenominatorGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionDenominatorGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func fractionDenomDisplayStyleGapMin() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.fractionDenomDisplayStyleGapMin {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func skewedFractionHorizontalGap() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.skewedFractionHorizontalGap {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func skewedFractionVerticalGap() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.skewedFractionVerticalGap {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func overbarVerticalGap() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.overbarVerticalGap {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func overbarRuleThickness() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.overbarRuleThickness {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func overbarExtraAscender() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.overbarExtraAscender {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func underbarVerticalGap() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.underbarVerticalGap {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func underbarRuleThickness() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.underbarRuleThickness {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func underbarExtraDescender() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.underbarExtraDescender {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func radicalVerticalGap() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.radicalVerticalGap {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func radicalDisplayStyleVerticalGap() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.radicalDisplayStyleVerticalGap {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func radicalRuleThickness() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.radicalRuleThickness {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func radicalExtraAscender() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.radicalExtraAscender {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func radicalKernBeforeDegree() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.radicalKernBeforeDegree {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func radicalKernAfterDegree() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.radicalKernAfterDegree {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    public func radicalDegreeBottomRaisePercent() -> CGFloat {
        if let value = self.mathTable?.mathConstantsTable?.radicalDegreeBottomRaisePercent {
            return CGFloat(value) / 100
        }
        else {
            return 0
        }
    }
}

extension OTFont {
    /// Returns the italics correction of the glyph or zero
    public func getGlyphItalicsCorrection(glyph: UInt16) -> CGFloat {
        let value = self.mathTable?.mathGlyphInfoTable?.mathItalicsCorrectionInfoTable?.getItalicsCorrection(glyph: glyph)
        if let value = value {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    /// Returns the top accent attachment of the glyph or 0.5 * the advance width of glyph
    public func getGlyphTopAccentAttachment(glyph: UInt16) -> CGFloat {
        // TODO: implement this
        0
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
