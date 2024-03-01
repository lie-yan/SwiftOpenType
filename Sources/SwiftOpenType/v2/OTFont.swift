import CoreText

/// A wrapper of CTFont, extended with some contexts
public class OTFont {
    let font: CTFont
    public let ppem: UInt32 /// pixels-per-em
    public let sizePerUnit: CGFloat
    
    convenience init(font: CTFont) {
        self.init(font: font, ppem: 0)
    }
    
    init(font: CTFont, ppem: UInt32) {
        self.font = font
        self.ppem = ppem
        self.sizePerUnit = CTFontGetSize(font) / CGFloat(CTFontGetUnitsPerEm(font))
    }
    
    // MARK: - Generic API
    
    public var unitsPerEm: UInt32 {
        CTFontGetUnitsPerEm(font)
    }
    
    public func getGlyphWithName(_ glyphName: CFString) -> CGGlyph {
        CTFontGetGlyphWithName(font, glyphName)
    }
    
    public func getGlyphWithName(_ glyphName: String) -> CGGlyph {
        CTFontGetGlyphWithName(font, glyphName as! CFString)
    }
    
    /// Return advance for glyph in points
    public func getAdvanceForGlyph(orientation: CTFontOrientation, glyph: CGGlyph) -> CGFloat {
        var glyph = glyph
        return CTFontGetAdvancesForGlyphs(font, orientation, &glyph, nil, 1)
    }
    
    // MARK: - tables
    
    public var mathTable: MathTableV2? {
        self._mathTable
    }
    
    private lazy var _mathTable : MathTableV2? = {
        if let data = self.getMathTableData() {
            let table = MathTableV2(base: CFDataGetBytePtr(data),
                                    context: self.getContextData())
            if table.majorVersion() == 1 {
                return table
            }
        }
        return nil
    }()
    
    // MARK: - for internal use
    
    internal func getContextData() -> ContextData {
        ContextData(ppem: self.ppem, unitsPerEm: self.unitsPerEm)
    }
    
    internal func getMathTableData() -> CFData? {
        CTFontCopyTable(font,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
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
        CGFloat(self.mathTable?.mathConstantsTable?.scriptPercentScaleDown ?? 0) / 100
    }
    
    public func scriptScriptPercentScaleDown() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.scriptScriptPercentScaleDown ?? 0) / 100
    }
    
    public func delimitedSubFormulaMinHeight() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.delimitedSubFormulaMinHeight ?? 0) * self.sizePerUnit
    }
    
    public func displayOperatorMinHeight() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.displayOperatorMinHeight ?? 0) * self.sizePerUnit
    }
    
    public func mathLeading() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.mathLeading ?? 0) * self.sizePerUnit
    }
    
    public func axisHeight() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.axisHeight ?? 0) * self.sizePerUnit
    }
    
    public func accentBaseHeight() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.accentBaseHeight ?? 0) * self.sizePerUnit
    }
    
    public func flattenedAccentBaseHeight() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.flattenedAccentBaseHeight ?? 0) * self.sizePerUnit
    }
    
    public func subscriptShiftDown() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.subscriptShiftDown ?? 0) * self.sizePerUnit
    }
    
    public func subscriptTopMax() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.subscriptTopMax ?? 0) * self.sizePerUnit
    }
    
    public func subscriptBaselineDropMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.subscriptBaselineDropMin ?? 0) * self.sizePerUnit
    }
    
    public func superscriptShiftUp() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.superscriptShiftUp ?? 0) * self.sizePerUnit
    }
    
    public func superscriptShiftUpCramped() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.superscriptShiftUpCramped ?? 0) * self.sizePerUnit
    }
    
    public func superscriptBottomMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.superscriptBottomMin ?? 0) * self.sizePerUnit
    }
    
    public func superscriptBaselineDropMax() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.superscriptBaselineDropMax ?? 0) * self.sizePerUnit
    }
    
    public func subSuperscriptGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.subSuperscriptGapMin ?? 0) * self.sizePerUnit
    }
    
    public func superscriptBottomMaxWithSubscript() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.superscriptBottomMaxWithSubscript ?? 0) * self.sizePerUnit
    }
    
    public func spaceAfterScript() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.spaceAfterScript ?? 0) * self.sizePerUnit
    }
    
    public func upperLimitGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.upperLimitGapMin ?? 0) * self.sizePerUnit
    }
    
    public func upperLimitBaselineRiseMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.upperLimitBaselineRiseMin ?? 0) * self.sizePerUnit
    }
    
    public func lowerLimitGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.lowerLimitGapMin ?? 0) * self.sizePerUnit
    }
    
    public func lowerLimitBaselineDropMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.lowerLimitBaselineDropMin ?? 0) * self.sizePerUnit
    }
    
    public func stackTopShiftUp() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stackTopShiftUp ?? 0) * self.sizePerUnit
    }
    
    public func stackTopDisplayStyleShiftUp() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stackTopDisplayStyleShiftUp ?? 0) * self.sizePerUnit
    }
    
    public func stackBottomShiftDown() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stackBottomShiftDown ?? 0) * self.sizePerUnit
    }
    
    public func stackBottomDisplayStyleShiftDown() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stackBottomDisplayStyleShiftDown ?? 0) * self.sizePerUnit
    }
    
    public func stackGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stackGapMin ?? 0) * self.sizePerUnit
    }
    
    public func stackDisplayStyleGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stackDisplayStyleGapMin ?? 0) * self.sizePerUnit
    }
    
    public func stretchStackTopShiftUp() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stretchStackTopShiftUp ?? 0) * self.sizePerUnit
    }
    
    public func stretchStackBottomShiftDown() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stretchStackBottomShiftDown ?? 0) * self.sizePerUnit
    }
    
    public func stretchStackGapAboveMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stretchStackGapAboveMin ?? 0) * self.sizePerUnit
    }
    
    public func stretchStackGapBelowMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.stretchStackGapBelowMin ?? 0) * self.sizePerUnit
    }
    
    public func fractionNumeratorShiftUp() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionNumeratorShiftUp ?? 0) * self.sizePerUnit
    }
    
    public func fractionNumeratorDisplayStyleShiftUp() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionNumeratorDisplayStyleShiftUp ?? 0) * self.sizePerUnit
    }
    
    public func fractionDenominatorShiftDown() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionDenominatorShiftDown ?? 0) * self.sizePerUnit
    }
    
    public func fractionDenominatorDisplayStyleShiftDown() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionDenominatorDisplayStyleShiftDown ?? 0) * self.sizePerUnit
    }
    
    public func fractionNumeratorGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionNumeratorGapMin ?? 0) * self.sizePerUnit
    }
    
    public func fractionNumDisplayStyleGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionNumDisplayStyleGapMin ?? 0) * self.sizePerUnit
    }
    
    public func fractionRuleThickness() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionRuleThickness ?? 0) * self.sizePerUnit
    }
    
    public func fractionDenominatorGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionDenominatorGapMin ?? 0) * self.sizePerUnit
    }
    
    public func fractionDenomDisplayStyleGapMin() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.fractionDenomDisplayStyleGapMin ?? 0) * self.sizePerUnit
    }
    
    public func skewedFractionHorizontalGap() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.skewedFractionHorizontalGap ?? 0) * self.sizePerUnit
    }
    
    public func skewedFractionVerticalGap() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.skewedFractionVerticalGap ?? 0) * self.sizePerUnit
    }
    
    public func overbarVerticalGap() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.overbarVerticalGap ?? 0) * self.sizePerUnit
    }
    
    public func overbarRuleThickness() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.overbarRuleThickness ?? 0) * self.sizePerUnit
    }
    
    public func overbarExtraAscender() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.overbarExtraAscender ?? 0) * self.sizePerUnit
    }
    
    public func underbarVerticalGap() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.underbarVerticalGap ?? 0) * self.sizePerUnit
    }
    
    public func underbarRuleThickness() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.underbarRuleThickness ?? 0) * self.sizePerUnit
    }
    
    public func underbarExtraDescender() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.underbarExtraDescender ?? 0) * self.sizePerUnit
    }
    
    public func radicalVerticalGap() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.radicalVerticalGap ?? 0) * self.sizePerUnit
    }
    
    public func radicalDisplayStyleVerticalGap() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.radicalDisplayStyleVerticalGap ?? 0) * self.sizePerUnit
    }
    
    public func radicalRuleThickness() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.radicalRuleThickness ?? 0) * self.sizePerUnit
    }
    
    public func radicalExtraAscender() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.radicalExtraAscender ?? 0) * self.sizePerUnit
    }
    
    public func radicalKernBeforeDegree() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.radicalKernBeforeDegree ?? 0) * self.sizePerUnit
    }
    
    public func radicalKernAfterDegree() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.radicalKernAfterDegree ?? 0) * self.sizePerUnit
    }
    
    public func radicalDegreeBottomRaisePercent() -> CGFloat {
        CGFloat(self.mathTable?.mathConstantsTable?.radicalDegreeBottomRaisePercent ?? 0) / 100
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
        let value = self.mathTable?.mathGlyphInfoTable?.mathTopAccentAttachmentTable?.getTopAccentAttachment(glyph: glyph)
        if let value = value {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return self.getAdvanceForGlyph(orientation: .horizontal, glyph: glyph) / 2
        }
    }
    
    /// Returns requested kerning value or zero
    public func getGlyphKerning(glyph: UInt16,
                                corner: MathKernCorner,
                                correctionHeight: CGFloat) -> CGFloat {
        let h = Int32(correctionHeight / self.sizePerUnit) // correction height in design units
        let value = self.mathTable?.mathGlyphInfoTable?.mathKernInfoTable?.getKernValue(glyph: glyph,
                                                                                        corner: corner,
                                                                                        height: h)
        if let value = value {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
    }
    
    /// Returns true if the glyph is an extended shape, false otherwise
    public func isGlyphExtendedShape(glyph: UInt16) -> Bool {
        let value = self.mathTable?.mathGlyphInfoTable?.extendedShapeCoverageTable?.getCoverageIndex(glyph: glyph)
        return value != nil
    }
    
    /// Returns requested minimum connector overlap or zero
    public func getMinConnectorOverlap(orientation: Orientation) -> CGFloat {
        let value = self.mathTable?.mathVariantsTable?.minConnectorOverlap()
        if let value = value {
            return CGFloat(value) * self.sizePerUnit
        }
        else {
            return 0
        }
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
