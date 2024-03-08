import CoreFoundation

public extension OTFont {
    /// Returns the italics correction of the glyph or zero
    func getGlyphItalicsCorrection(_ glyph: UInt16) -> CGFloat {
        let value = mathTable?.mathGlyphInfoTable?.mathItalicsCorrectionInfoTable?.getItalicsCorrection(glyph)
        return CGFloat(value ?? 0) * sizePerUnit
    }

    /// Returns the top accent attachment of the glyph or 0.5 * the advance width of glyph
    func getGlyphTopAccentAttachment(_ glyph: UInt16) -> CGFloat {
        let value = mathTable?.mathGlyphInfoTable?.mathTopAccentAttachmentTable?.getTopAccentAttachment(glyph)
        if let value = value {
            return CGFloat(value) * sizePerUnit
        } else {
            return 0.5 * getAdvanceForGlyph(.horizontal, glyph)
        }
    }

    /// Returns requested kerning value or zero
    func getGlyphKerning(_ glyph: UInt16,
                         _ corner: MathKernCorner,
                         _ correctionHeight: CGFloat) -> CGFloat
    {
        let h = Int32(correctionHeight / sizePerUnit) // correction height in design units
        let value = mathTable?.mathGlyphInfoTable?.mathKernInfoTable?.getKernValue(glyph, corner, h)
        return CGFloat(value ?? 0) * sizePerUnit
    }

    /// Fetches the raw MathKern (cut-in) data for glyph index, and corner.
    ///
    /// - Parameters:
    ///   - glyph: The glyph index from which to retrieve the kernings
    ///   - corner: The corner for which to retrieve the kernings
    ///   - startOffset: offset of the first kern entry to retrieve
    ///   - entriesCount: Input = the maximum number of kern entries to return;
    ///     Output = the actual number of kern entries returned.
    ///   - kernEntries: array of kern entries returned.
    ///
    /// - Returns: the total number of kern values available or zero
    func getGlyphKernings(_ glyph: UInt16,
                          _ corner: MathKernCorner,
                          _ startOffset: Int,
                          _ entriesCount: inout Int,
                          _ kernEntries: inout [MathKernEntry]) -> Int
    {
        precondition(startOffset >= 0)
        precondition(entriesCount >= 0)
        precondition(kernEntries.count >= entriesCount)

        if let kernTable = mathTable?.mathGlyphInfoTable?.mathKernInfoTable?
            .getMathKernTable(glyph, corner)
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
                    maxHeight = CGFloat(kernTable.getCorrectionHeight(j)) * sizePerUnit
                }

                let kernValue = CGFloat(kernTable.getKernValue(index: j)) * sizePerUnit
                kernEntries[i] = MathKernEntry(maxCorrectionHeight: maxHeight, kernValue: kernValue)
            }
            return entriesCount
        }

        // FALL THRU
        entriesCount = 0
        return 0
    }

    /// Returns the count of kern entries available for glyph index and corner, counting from given offset.
    ///
    /// - Parameters:
    ///   - glyph: The glyph index from which to retrieve the kernings
    ///   - corner: The corner for which to retrieve the kernings
    ///   - startOffset: offset of the first kern entry to retrieve
    ///
    /// - Returns: the total number of kern values available or zero
    func getGlyphKerningCount(_ glyph: UInt16,
                              _ corner: MathKernCorner,
                              _ startOffset: Int) -> Int
    {
        precondition(startOffset >= 0)
        return mathTable?.mathGlyphInfoTable?.mathKernInfoTable?
            .getMathKernTable(glyph, corner)?
            .getKernEntryCount(startOffset: startOffset) ?? 0
    }

    /// Returns true if the glyph is an extended shape, false otherwise
    func isGlyphExtendedShape(_ glyph: UInt16) -> Bool {
        mathTable?.mathGlyphInfoTable?.extendedShapeCoverageTable?.getCoverageIndex(glyph) != nil
    }
}

public struct MathKernEntry {
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
