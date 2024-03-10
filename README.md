# SwiftOpenType

API for OpenType tables. 

## Status

Access to `MATH` table is fully supported.


| harfbuzz | SwiftOpenType |
|--|--|
| hb_ot_math_has_data | hasData |
| hb_ot_math_get_constant | getConstant |
| hb_ot_math_get_glyph_italics_correction | getGlyphItalicsCorrection|
| hb_ot_math_get_glyph_top_accent_attachment | getGlyphTopAccentAttachment |
| hb_ot_math_get_glyph_kerning | getGlyphKerning |
| hb_ot_math_get_glyph_kernings | getGlyphKernings, <br> getGlyphKerningCount |
| hb_ot_math_is_glyph_extended_shape | isGlyphExtendedShape |
| hb_ot_math_get_glyph_variants | getGlyphVariants, <br> getGlyphVariantCount |
| hb_ot_math_get_min_connector_overlap | getMinConnectorOverlap |
| hb_ot_math_get_glyph_assembly | getGlyphAssembly, <br> getGlyphAssemblyItalicsCorrection, <br> getGlyphAssemblyParts, <br> getGlyphAssemblyPartCount |



## Example


```swift
do {
    let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
    let mathData = helvetica.createCachedMathData()
    if !mathData.hasData() {
        print("no MATH table")
    }
}

do {
    let lmmath = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)
    let mathData = lmmath.createCachedMathData()
    print("axis height, in pts: \(mathData.getConstant(.axisHeight))")
    print("axis height, in pts: \(mathData.axisHeight())")
}
```


## Tests

See `MathTableTests`


## See also

[OpenTypeSwift] is the repository that this codebase evolved from, which supports math constants.

[OpenType Specification] is the best reference. 


[OpenTypeSwift]: https://github.com/mossprescott/OpenTypeSwift
[OpenType Specification]: https://learn.microsoft.com/en-us/typography/opentype/spec/
