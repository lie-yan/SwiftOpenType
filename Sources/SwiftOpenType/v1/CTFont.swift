import CoreText

extension CTFont {
    public var mathTable: MathTable? {
        if let data = self.getMathTableData() {
            let table = MathTable(data: data)
            if table.majorVersion() == 1 {
                return table
            }
        }
        return nil
    }

    public func sizePerUnit() -> CGFloat {
        CTFontGetSize(self) / CGFloat(CTFontGetUnitsPerEm(self))
    }

    private func getMathTableData() -> CFData? {
        CTFontCopyTable(self,
                        CTFontTableTag(kCTFontTableMATH),
                        CTFontTableOptions(rawValue: 0))
    }
}

