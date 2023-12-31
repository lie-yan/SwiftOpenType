import CoreText

extension CTFont {
    public func hasMathTable() -> Bool {
        if getMathTableData(font: self) != nil {
            return true
        }
        return false
    }
}

private func getMathTableData(font: CTFont) -> CFData? {
    return CTFontCopyTable(font, CTFontTableTag(kCTFontTableMATH), CTFontTableOptions(rawValue: 0))
}
