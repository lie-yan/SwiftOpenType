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

    func getBoundingRectForGlyph(_ orientation: CTFontOrientation,
                                 _ glyph: CGGlyph) -> CGRect
    {
        withUnsafePointer(to: glyph) {
            CTFontGetBoundingRectsForGlyphs(font, orientation, $0, nil, 1)
        }
    }

    func getBoundingRectForGlyphs(_ orientation: CTFontOrientation,
                                  _ glyphs: [CGGlyph]) -> CGRect
    {
        glyphs.withUnsafeBufferPointer {
            CTFontGetBoundingRectsForGlyphs(font, orientation, $0.baseAddress!, nil, $0.count)
        }
    }

    func getBoundingRectsForGlyphs(_ orientation: CTFontOrientation,
                                   _ glyphs: [CGGlyph],
                                   _ boundingRects: inout [CGRect]) -> CGRect
    {
        precondition(glyphs.count == boundingRects.count)
        return glyphs.withUnsafeBufferPointer {
            glyphs in boundingRects.withUnsafeMutableBufferPointer {
                boundingRects in CTFontGetBoundingRectsForGlyphs(font,
                                                                 orientation,
                                                                 glyphs.baseAddress!,
                                                                 boundingRects.baseAddress!,
                                                                 glyphs.count)
            }
        }
    }

    func getAdvanceForGlyph(_ orientation: CTFontOrientation,
                            _ glyph: CGGlyph) -> CGFloat
    {
        withUnsafePointer(to: glyph) {
            CTFontGetAdvancesForGlyphs(font, orientation, $0, nil, 1)
        }
    }

    func getAdvanceForGlyphs(_ orientation: CTFontOrientation,
                             _ glyphs: [CGGlyph]) -> CGFloat
    {
        glyphs.withUnsafeBufferPointer {
            CTFontGetAdvancesForGlyphs(font, orientation, $0.baseAddress!, nil, $0.count)
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

    // MARK: - Working with Glyphs

    /// - Parameters:
    ///     - character: codepoint encoded in UTF-16
    /// - Returns:
    ///     the corresponding glyph id, or nil
    func getGlyphForCharacter(_ character: [UniChar]) -> CGGlyph? {
        var glyph: CGGlyph = 0
        let success = character.withUnsafeBufferPointer {
            character in withUnsafeMutablePointer(to: &glyph) {
                glyph in CTFontGetGlyphsForCharacters(font, character.baseAddress!, glyph, 1)
            }
        }
        return success ? glyph : nil
    }

    /// - Parameters:
    ///     - characters:
    ///         An array of Unicode characters.
    ///     - glyphs:
    ///         On output, points to an array of glyph values.
    /// - Returns:
    ///     `True` if the font could encode all Unicode characters; otherwise `False`.
    ///
    /// If a glyph could not be encoded, a value of `0` is passed back at the 
    /// corresponding index in the `glyphs` array and the function returns `False`.
    /// It is the responsibility of the caller to handle the Unicode properties
    /// of the input characters.
    func getGlyphsForCharacters(_ characters: [UniChar],
                                _ glyphs: inout [CGGlyph]) -> Bool
    {
        precondition(characters.count >= glyphs.count)
        return characters.withUnsafeBufferPointer {
            characters in glyphs.withUnsafeMutableBufferPointer {
                glyphs in CTFontGetGlyphsForCharacters(font,
                                                       characters.baseAddress!,
                                                       glyphs.baseAddress!,
                                                       glyphs.count)
            }
        }
    }
}
