import CoreText

public class OTFont {
    let font: CTFont
    let ppem: UInt /// pixels-per-em
    
    convenience init(font: CTFont) {
        self.init(font: font, ppem: 0)
    }
    
    init(font: CTFont, ppem: UInt) {
        self.font = font
        self.ppem = ppem
    }
    
    public func sizePerUnit() -> CGFloat {
        CTFontGetSize(font) / CGFloat(CTFontGetUnitsPerEm(font))
    }
    
    private func getMathTableData() -> CFData? {
        CTFontCopyTable(font,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}
