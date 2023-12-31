import CoreText

extension CTFont {
    public func hasMathTable() -> Bool {
        if self.mathTable != nil {
            return true
        }
        return false
    }

    public var mathTable: MathTable? {
        if self.getMathTableData() != nil {
            let table = MathTable(font: self)
            if table.majorVersion == 1 {
                return table
            }
        }
        return nil
    }

    func getMathTableData() -> CFData? {
        CTFontCopyTable(self,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}

public class MathTable {
    let font: CTFont

    fileprivate init(font: CTFont) {
        self.font = font
    }

    /// Major version of the MATH table, = 1.
    public var majorVersion: UInt16 {
        readUnsigned16(offset: 0)
    }

    /// Minor version of the MATH table, = 0.
    public var minorVersion: UInt16 {
        readUnsigned16(offset: 2)
    }

    /// Offset to MathConstants table - from the beginning of MATH table.
    public var mathConstantsOffset: Offset16 {
        readUnsigned16(offset: 4)
    }

    /// Offset to MathGlyphInfo table - from the beginning of MATH table.
    public var mathGlyphInfoOffset: Offset16 {
        readUnsigned16(offset: 6)
    }

    /// Offset to MathVariants table - from the beginning of MATH table.
    public var mathVariantsOffset: Offset16 {
        readUnsigned16(offset: 8)
    }

    func readUnsigned16(offset: CFIndex) -> UInt16 {
        let ptr = CFDataGetBytePtr(font.getMathTableData()!)!
        return (ptr+offset).withMemoryRebound(to: UInt16.self, capacity: 1) {
            $0.pointee.byteSwapped
        }
    }
}

typealias FWORD = Int16     // int16 that describes a quantity in font design units.
typealias UFWORD = UInt16   // uint16 that describes a quantity in font design units.
public typealias Offset16 = UInt16 // Short offset to a table, same as uint16, NULL offset = 0x0000

struct MathValueRecord {
    let value: FWORD          // The X or Y value in design units
    let deviceTable: Offset16 // Offset to the device table — from the beginning of parent table.
                              // May be NULL. Suggested format for device table is 1.

    init() {
        self.init(value: 0, deviceTable: 0)
    }

    init(value: FWORD, deviceTable: Offset16) {
        self.value = value
        self.deviceTable = deviceTable
    }
}

public enum MathConstants {
    public static let
        scriptRatioScaleDown = 0,
        scriptScriptRatioScaleDown = 1,
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
        stretchStackGApBelowMin = 31,
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
        radicalDegreeBottomRaiseRatio = 55
}

class MathConstantsCache {
    init() {
        percentScaleDown = Array<Int16>(repeating: 0, count: 2)
        minHeight = Array<UInt16>(repeating: 0, count: 2)
        mathValueRecords = Array<MathValueRecord>(repeating: MathValueRecord(), count: 51)
        radicalDegreeBottomRaisePercent = 0
    }

    var percentScaleDown: [Int16]           // count: 2
    var minHeight: [UFWORD]                 // count: 2
    var mathValueRecords: [MathValueRecord] // count: 51
    var radicalDegreeBottomRaisePercent: Int16 // count: 1
}
