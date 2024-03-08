import CoreFoundation
import CoreText

public extension OTFont {
    func getSize() -> CGFloat { CTFontGetSize(font) }

    func getUnitsPerEm() -> UInt32 { CTFontGetUnitsPerEm(font) }

    func getGlyphWithName(_ glyphName: String) -> CGGlyph {
        CTFontGetGlyphWithName(font, glyphName as! CFString)
    }

    /// Returns advance for glyph in points
    func getAdvanceForGlyph(_ orientation: CTFontOrientation, _ glyph: CGGlyph) -> CGFloat {
        var glyph = glyph
        return CTFontGetAdvancesForGlyphs(font, orientation, &glyph, nil, 1)
    }
}
