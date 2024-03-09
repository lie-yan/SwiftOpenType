import CoreFoundation

public extension OTFont {
    /// Returns requested minimum connector overlap or zero
    func getMinConnectorOverlap(_: TextOrientation) -> CGFloat {
        let value = mathTable?.mathVariantsTable?.minConnectorOverlap()
        return CGFloat(value ?? 0) * sizePerUnit
    }

    func getGlyphVariants(
        _ glyph: UInt16,
        _ direction: TextDirection,
        _ startOffset: Int,
        _ variantsCount: inout Int,
        _ variants: inout [MathGlyphVariant]
    ) -> Int {
        glyph
        direction
        startOffset
        variantsCount
        variants
        // TODO: implement this
        return 0
    }
}
