# SwiftOpenType

Simple API for OpenType tables, extending `CTFont`. 

## Example

Check if the MATH table is present:

```swift
let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12.0, nil)
if helvetica.mathTable == nil {
    print("no MATH table")
}
```

Access a constant, scaled to the font size:

```swift
let lmmath = CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil)
let mathTable = lmmath.mathTable!
print("axis height, in pts: \(mathTable.axisHeight)")
```

## Tests

See `MathTableTests`

## Status

`MATH` table is fully supported.


## See also

[OpenTypeSwift](https://github.com/mossprescott/OpenTypeSwift) is the repository that this codebase evolved from.

Microsoft's [OpenType spec](https://learn.microsoft.com/en-us/typography/opentype/spec/) is the best reference. 
