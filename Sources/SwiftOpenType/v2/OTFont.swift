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
        _mathTable
    }

    private lazy var _mathTable: MathTableV2? = {
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

    func getContextData() -> ContextData {
        ContextData(ppem: ppem, unitsPerEm: unitsPerEm)
    }

    func getMathTableData() -> CFData? {
        CTFontCopyTable(font,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}

public extension OTFont {
    /// Return the requested constant or zero
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
        CGFloat(mathTable?.mathConstantsTable?.scriptPercentScaleDown ?? 0) / 100
    }

    func scriptScriptPercentScaleDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.scriptScriptPercentScaleDown ?? 0) / 100
    }

    func delimitedSubFormulaMinHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.delimitedSubFormulaMinHeight ?? 0) * sizePerUnit
    }

    func displayOperatorMinHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.displayOperatorMinHeight ?? 0) * sizePerUnit
    }

    func mathLeading() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.mathLeading ?? 0) * sizePerUnit
    }

    func axisHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.axisHeight ?? 0) * sizePerUnit
    }

    func accentBaseHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.accentBaseHeight ?? 0) * sizePerUnit
    }

    func flattenedAccentBaseHeight() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.flattenedAccentBaseHeight ?? 0) * sizePerUnit
    }

    func subscriptShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subscriptShiftDown ?? 0) * sizePerUnit
    }

    func subscriptTopMax() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subscriptTopMax ?? 0) * sizePerUnit
    }

    func subscriptBaselineDropMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subscriptBaselineDropMin ?? 0) * sizePerUnit
    }

    func superscriptShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptShiftUp ?? 0) * sizePerUnit
    }

    func superscriptShiftUpCramped() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptShiftUpCramped ?? 0) * sizePerUnit
    }

    func superscriptBottomMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptBottomMin ?? 0) * sizePerUnit
    }

    func superscriptBaselineDropMax() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptBaselineDropMax ?? 0) * sizePerUnit
    }

    func subSuperscriptGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.subSuperscriptGapMin ?? 0) * sizePerUnit
    }

    func superscriptBottomMaxWithSubscript() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.superscriptBottomMaxWithSubscript ?? 0) * sizePerUnit
    }

    func spaceAfterScript() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.spaceAfterScript ?? 0) * sizePerUnit
    }

    func upperLimitGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.upperLimitGapMin ?? 0) * sizePerUnit
    }

    func upperLimitBaselineRiseMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.upperLimitBaselineRiseMin ?? 0) * sizePerUnit
    }

    func lowerLimitGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.lowerLimitGapMin ?? 0) * sizePerUnit
    }

    func lowerLimitBaselineDropMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.lowerLimitBaselineDropMin ?? 0) * sizePerUnit
    }

    func stackTopShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackTopShiftUp ?? 0) * sizePerUnit
    }

    func stackTopDisplayStyleShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackTopDisplayStyleShiftUp ?? 0) * sizePerUnit
    }

    func stackBottomShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackBottomShiftDown ?? 0) * sizePerUnit
    }

    func stackBottomDisplayStyleShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackBottomDisplayStyleShiftDown ?? 0) * sizePerUnit
    }

    func stackGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackGapMin ?? 0) * sizePerUnit
    }

    func stackDisplayStyleGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stackDisplayStyleGapMin ?? 0) * sizePerUnit
    }

    func stretchStackTopShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackTopShiftUp ?? 0) * sizePerUnit
    }

    func stretchStackBottomShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackBottomShiftDown ?? 0) * sizePerUnit
    }

    func stretchStackGapAboveMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackGapAboveMin ?? 0) * sizePerUnit
    }

    func stretchStackGapBelowMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.stretchStackGapBelowMin ?? 0) * sizePerUnit
    }

    func fractionNumeratorShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumeratorShiftUp ?? 0) * sizePerUnit
    }

    func fractionNumeratorDisplayStyleShiftUp() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumeratorDisplayStyleShiftUp ?? 0) * sizePerUnit
    }

    func fractionDenominatorShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenominatorShiftDown ?? 0) * sizePerUnit
    }

    func fractionDenominatorDisplayStyleShiftDown() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenominatorDisplayStyleShiftDown ?? 0) * sizePerUnit
    }

    func fractionNumeratorGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumeratorGapMin ?? 0) * sizePerUnit
    }

    func fractionNumDisplayStyleGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionNumDisplayStyleGapMin ?? 0) * sizePerUnit
    }

    func fractionRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionRuleThickness ?? 0) * sizePerUnit
    }

    func fractionDenominatorGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenominatorGapMin ?? 0) * sizePerUnit
    }

    func fractionDenomDisplayStyleGapMin() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.fractionDenomDisplayStyleGapMin ?? 0) * sizePerUnit
    }

    func skewedFractionHorizontalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.skewedFractionHorizontalGap ?? 0) * sizePerUnit
    }

    func skewedFractionVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.skewedFractionVerticalGap ?? 0) * sizePerUnit
    }

    func overbarVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.overbarVerticalGap ?? 0) * sizePerUnit
    }

    func overbarRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.overbarRuleThickness ?? 0) * sizePerUnit
    }

    func overbarExtraAscender() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.overbarExtraAscender ?? 0) * sizePerUnit
    }

    func underbarVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.underbarVerticalGap ?? 0) * sizePerUnit
    }

    func underbarRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.underbarRuleThickness ?? 0) * sizePerUnit
    }

    func underbarExtraDescender() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.underbarExtraDescender ?? 0) * sizePerUnit
    }

    func radicalVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalVerticalGap ?? 0) * sizePerUnit
    }

    func radicalDisplayStyleVerticalGap() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalDisplayStyleVerticalGap ?? 0) * sizePerUnit
    }

    func radicalRuleThickness() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalRuleThickness ?? 0) * sizePerUnit
    }

    func radicalExtraAscender() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalExtraAscender ?? 0) * sizePerUnit
    }

    func radicalKernBeforeDegree() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalKernBeforeDegree ?? 0) * sizePerUnit
    }

    func radicalKernAfterDegree() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalKernAfterDegree ?? 0) * sizePerUnit
    }

    func radicalDegreeBottomRaisePercent() -> CGFloat {
        CGFloat(mathTable?.mathConstantsTable?.radicalDegreeBottomRaisePercent ?? 0) / 100
    }
}

public extension OTFont {
    /// Returns the italics correction of the glyph or zero
    func getGlyphItalicsCorrection(glyph: UInt16) -> CGFloat {
        let value = mathTable?.mathGlyphInfoTable?.mathItalicsCorrectionInfoTable?
            .getItalicsCorrection(glyph: glyph)
        return CGFloat(value ?? 0) * sizePerUnit
    }

    /// Returns the top accent attachment of the glyph or 0.5 * the advance width of glyph
    func getGlyphTopAccentAttachment(glyph: UInt16) -> CGFloat {
        let value = mathTable?
            .mathGlyphInfoTable?
            .mathTopAccentAttachmentTable?
            .getTopAccentAttachment(glyph: glyph)
        if let value = value {
            return CGFloat(value) * sizePerUnit
        } else {
            return 0.5 * getAdvanceForGlyph(orientation: .horizontal, glyph: glyph)
        }
    }

    /// Returns requested kerning value or zero
    func getGlyphKerning(glyph: UInt16,
                         corner: MathKernCorner,
                         correctionHeight: CGFloat) -> CGFloat
    {
        let h = Int32(correctionHeight / sizePerUnit) // correction height in design units
        let value = mathTable?.mathGlyphInfoTable?.mathKernInfoTable?.getKernValue(glyph: glyph,
                                                                                   corner: corner,
                                                                                   height: h)
        return CGFloat(value ?? 0) * sizePerUnit
    }

    /// Fetches the raw MathKern (cut-in) data for glyph index, and corner.
    ///
    /// - Parameters:
    ///   - glyph: The glyph index from which to retrieve the kernings
    ///   - corner: The corner for which to retrieve the kernings
    ///   - start_offset: offset of the first kern entry to retrieve
    ///   - entries_count: Input = the maximum number of kern entries to return;
    ///     Output = the actual number of kern entries returned.
    ///   - kern_entries: array of kern entries returned.
    ///
    /// - Returns: the total number of kern values available or zero
    func getGlyphKernings(glyph: UInt16,
                          corner: MathKernCorner,
                          startOffset: Int,
                          entriesCount: inout Int,
                          kernEntries: inout [KernEntry]) -> Int
    {
        precondition(startOffset >= 0)
        precondition(entriesCount >= 0)
        precondition(kernEntries.count >= entriesCount)

        if let kernTable = mathTable?.mathGlyphInfoTable?.mathKernInfoTable?
            .getMathKernTable(glyph: glyph, corner: corner)
        {
            let heightCount = Int(kernTable.heightCount())
            let count = heightCount + 1
            let start = min(startOffset, count)
            let end = min(start + entriesCount, count)
            entriesCount = end - start

            for i in 0 ..< entriesCount {
                let j = start + i

                var maxHeight: CGFloat
                if j == heightCount {
                    maxHeight = CGFloat.infinity
                } else {
                    maxHeight = CGFloat(kernTable.getCorrectionHeight(index: j)) * sizePerUnit
                }

                let kernValue = CGFloat(kernTable.getKernValue(index: j)) * sizePerUnit
                kernEntries[i] = KernEntry(maxCorrectionHeight: maxHeight,
                                           kernValue: kernValue)
            }
            return entriesCount
        }

        // FALL THRU
        entriesCount = 0
        return 0
    }

    /// Return the kern entries available for glyph index and corner, counting from given offset.
    ///
    /// - Parameters:
    ///   - glyph: The glyph index from which to retrieve the kernings
    ///   - corner: The corner for which to retrieve the kernings
    ///   - start_offset: offset of the first kern entry to retrieve
    ///
    /// - Returns: the total number of kern values available or zero
    func getGlyphKerningCount(glyph: UInt16,
                              corner: MathKernCorner,
                              startOffset: Int) -> Int
    {
        precondition(startOffset >= 0)
        return mathTable?.mathGlyphInfoTable?.mathKernInfoTable?
            .getMathKernTable(glyph: glyph, corner: corner)?
            .getKernEntryCount(startOffset: startOffset) ?? 0
    }

    /// Returns true if the glyph is an extended shape, false otherwise
    func isGlyphExtendedShape(glyph: UInt16) -> Bool {
        let value = mathTable?.mathGlyphInfoTable?.extendedShapeCoverageTable?.getCoverageIndex(glyph: glyph)
        return value != nil
    }

    /// Returns requested minimum connector overlap or zero
    func getMinConnectorOverlap(orientation _: Orientation) -> CGFloat {
        let value = mathTable?.mathVariantsTable?.minConnectorOverlap()
        return CGFloat(value ?? 0) * sizePerUnit
    }
}

class ContextData {
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

public struct KernEntry {
    let maxCorrectionHeight: CGFloat
    let kernValue: CGFloat

    init(maxCorrectionHeight: CGFloat, kernValue: CGFloat) {
        self.maxCorrectionHeight = maxCorrectionHeight
        self.kernValue = kernValue
    }
    
    init() {
        self.init(maxCorrectionHeight: 0, kernValue: 0)
    }
}
