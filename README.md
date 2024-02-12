# SwiftOpenType

Simple API for OpenType tables. 

## Example

Check if the MATH table is present:

```swift
let helvetica = OTFont(font: CTFontCreateWithName("Helvetica" as CFString, 12.0, nil))
if helvetica.mathTable == nil {
    print("no MATH table")
}
```

Access a math constant, in points:

```swift
let lmmath = OTFont(font: CTFontCreateWithName("Latin Modern Math" as CFString, 12.0, nil))
print("axis height, in pts: \(lmmath.axisHeight())")
```

## Tests

See `MathTableTests`

## Status

`MATH` table is fully supported.


## See also

[OpenTypeSwift](https://github.com/mossprescott/OpenTypeSwift) is the repository that this codebase evolved from, which supports math constants.
