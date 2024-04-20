import CoreText

public extension CTFont {
    func getSize() -> CGFloat {
        CTFontGetSize(self)
    }

    /// Returns a lambda that converts design units to points
    func toPointsClosure() -> ((Int32) -> CGFloat) {
        let sizePerUnit = getSize() / CGFloat(getUnitsPerEm())
        return { CGFloat($0) * sizePerUnit }
    }

    /// Returns a lambda that converts points to design units
    func toDesignUnitsClosure() -> ((CGFloat) -> Int32) {
        let sizePerUnit = getSize() / CGFloat(getUnitsPerEm())
        return { Int32($0 / sizePerUnit) }
    }

    // MARK: - Getting Font Metrics (complete)

    func getAscent() -> CGFloat {
        CTFontGetAscent(self)
    }

    func getDescent() -> CGFloat {
        CTFontGetDescent(self)
    }

    func getLeading() -> CGFloat {
        CTFontGetLeading(self)
    }

    func getUnitsPerEm() -> UInt32 {
        CTFontGetUnitsPerEm(self)
    }

    func getGlyphCount() -> Int {
        CTFontGetGlyphCount(self)
    }

    func getBoundingBox() -> CGRect {
        CTFontGetBoundingBox(self)
    }

    func getUnderlinePosition() -> CGFloat {
        CTFontGetUnderlinePosition(self)
    }

    func getUnderlineThickness() -> CGFloat {
        CTFontGetUnderlineThickness(self)
    }

    func getSlantAngle() -> CGFloat {
        CTFontGetSlantAngle(self)
    }

    func getCapHeight() -> CGFloat {
        CTFontGetCapHeight(self)
    }

    func getXHeight() -> CGFloat {
        CTFontGetXHeight(self)
    }

    // MARK: - Getting Glyph Data

    func getGlyphWithName(_ glyphName: String) -> CGGlyph {
        CTFontGetGlyphWithName(self, glyphName as! CFString)
    }

    func getBoundingRectForGlyph(_ orientation: CTFontOrientation,
                                 _ glyph: CGGlyph) -> CGRect
    {
        withUnsafePointer(to: glyph) {
            CTFontGetBoundingRectsForGlyphs(self, orientation, $0, nil, 1)
        }
    }

    func getBoundingRectForGlyphs(_ orientation: CTFontOrientation,
                                  _ glyphs: [CGGlyph]) -> CGRect
    {
        glyphs.withUnsafeBufferPointer {
            CTFontGetBoundingRectsForGlyphs(self, orientation, $0.baseAddress!, nil, $0.count)
        }
    }

    func getBoundingRectsForGlyphs(_ orientation: CTFontOrientation,
                                   _ glyphs: [CGGlyph],
                                   _ boundingRects: inout [CGRect]) -> CGRect
    {
        precondition(glyphs.count == boundingRects.count)
        return glyphs.withUnsafeBufferPointer {
            glyphs in boundingRects.withUnsafeMutableBufferPointer {
                boundingRects in CTFontGetBoundingRectsForGlyphs(self,
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
            CTFontGetAdvancesForGlyphs(self, orientation, $0, nil, 1)
        }
    }

    func getAdvanceForGlyphs(_ orientation: CTFontOrientation,
                             _ glyphs: [CGGlyph]) -> CGFloat
    {
        glyphs.withUnsafeBufferPointer {
            CTFontGetAdvancesForGlyphs(self, orientation, $0.baseAddress!, nil, $0.count)
        }
    }

    func getAdvancesForGlyphs(_ orientation: CTFontOrientation,
                              _ glyphs: [CGGlyph],
                              _ advances: inout [CGSize]) -> CGFloat
    {
        precondition(glyphs.count == advances.count)
        return glyphs.withUnsafeBufferPointer {
            glyphs in advances.withUnsafeMutableBufferPointer {
                advances in CTFontGetAdvancesForGlyphs(self,
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
                glyph in CTFontGetGlyphsForCharacters(self, character.baseAddress!, glyph, 1)
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
                glyphs in CTFontGetGlyphsForCharacters(self,
                                                       characters.baseAddress!,
                                                       glyphs.baseAddress!,
                                                       glyphs.count)
            }
        }
    }

    // MARK: - Table data

    internal func getMathTableData() -> CFData? {
        CTFontCopyTable(self,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }

    internal func getMathTable(ppem: UInt32 = 0) -> MathTable? {
        if let data = getMathTableData() {
            let table = MathTable(base: CFDataGetBytePtr(data),
                                  context: ContextData(ppem: ppem, unitsPerEm: getUnitsPerEm()))
            if table.majorVersion() == 1 {
                return table
            }
        }
        return nil
    }

    func createCachedMathTable(ppem: UInt32 = 0) -> CachedMathTable {
        CachedMathTable(self, ppem: ppem)
    }
}
