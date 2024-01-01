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

The Latin Modern Math font is required to run the tests. It can be downloaded from [GUST](https://www.gust.org.pl/projects/e-foundry/lm-math).

## Status

Currently we focus on `MATH` table. 


## See also

[OpenTypeSwift](https://github.com/mossprescott/OpenTypeSwift) is the repository that this codebase evolved from.

Microsoft's [OpenType spec](https://learn.microsoft.com/en-us/typography/opentype/spec/) is the best reference. 