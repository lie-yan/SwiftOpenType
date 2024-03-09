import CoreFoundation
import CoreText

public extension OTFont {
    func getSize() -> CGFloat {
        CTFontGetSize(font)
    }

    // MARK: - Getting Font Metrics (complete)

    func getAscent() -> CGFloat {
        CTFontGetAscent(font)
    }

    func getDescent() -> CGFloat {
        CTFontGetDescent(font)
    }

    func getLeading() -> CGFloat {
        CTFontGetLeading(font)
    }

    func getUnitsPerEm() -> UInt32 {
        CTFontGetUnitsPerEm(font)
    }

    func getGlyphCount() -> Int {
        CTFontGetGlyphCount(font)
    }

    func getBoundingBox() -> CGRect {
        CTFontGetBoundingBox(font)
    }

    func getUnderlinePosition() -> CGFloat {
        CTFontGetUnderlinePosition(font)
    }

    func getUnderlineThickness() -> CGFloat {
        CTFontGetUnderlineThickness(font)
    }

    func getSlantAngle() -> CGFloat {
        CTFontGetSlantAngle(font)
    }

    func getCapHeight() -> CGFloat {
        CTFontGetCapHeight(font)
    }

    func getXHeight() -> CGFloat {
        CTFontGetXHeight(font)
    }

    // MARK: - Getting Glyph Data

    func getGlyphWithName(_ glyphName: String) -> CGGlyph {
        CTFontGetGlyphWithName(font, glyphName as! CFString)
    }

    func getAdvanceForGlyph(_ orientation: CTFontOrientation,
                            _ glyph: CGGlyph) -> CGFloat
    {
        withUnsafePointer(to: glyph) {
            CTFontGetAdvancesForGlyphs(font, orientation, $0, nil, 1)
        }
    }

    func getAdvancesForGlyphs(_ orientation: CTFontOrientation,
                              _ glyphs: [CGGlyph],
                              _ advances: inout [CGSize]) -> CGFloat
    {
        precondition(glyphs.count == advances.count)
        return glyphs.withUnsafeBufferPointer {
            glyphs in advances.withUnsafeMutableBufferPointer {
                advances in CTFontGetAdvancesForGlyphs(font,
                                                       orientation,
                                                       glyphs.baseAddress!,
                                                       advances.baseAddress!,
                                                       glyphs.count)
            }
        }
    }
}
