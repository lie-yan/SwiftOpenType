# SwiftOpenType

API for OpenType tables. 

## Status

Access to `MATH` table is fully supported.


| harfbuzz | SwiftOpenType |
|--|--|
| hb_ot_math_has_data | OTFont.mathTable != nil |
| hb_ot_math_get_constant | getMathConstant |
| hb_ot_math_get_glyph_italics_correction | getGlyphItalicsCorrection|
| hb_ot_math_get_glyph_top_accent_attachment | getGlyphTopAccentAttachment |
| hb_ot_math_get_glyph_kerning | getGlyphKerning |
| hb_ot_math_get_glyph_kernings | getGlyphKernings, <br> getGlyphKerningCount |
| hb_ot_math_is_glyph_extended_shape | isGlyphExtendedShape |
| hb_ot_math_get_glyph_variants | getGlyphVariants, <br> getGlyphVariantCount |
| hb_ot_math_get_min_connector_overlap | getMinConnectorOverlap |
| hb_ot_math_get_glyph_assembly | getGlyphAssembly, <br> getGlyphAssemblyItalicsCorrection, <br> getGlyphAssemblyParts, <br> getGlyphAssemblyPartsCount |



## Example


```swift
let helvetica = OTFont(CTFontCreateWithName("Helvetica" as CFString, 12.0, nil))
if helvetica.mathTable == nil {
    print("no MATH table")
}

let lmmath = OTFont(CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil))
print("axis height, in pts: \(lmmath.axisHeight())")
```


## Tests

See `MathTableTests`


## See also

[OpenTypeSwift](https://github.com/mossprescott/OpenTypeSwift) is the repository that this codebase evolved from, which supports math constants.

[OpenType Specification](https://learn.microsoft.com/en-us/typography/opentype/spec/) is the best reference. 
