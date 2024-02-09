import CoreFoundation


public class MathTableV2 {
    let base: UnsafePointer<UInt8>
    
    init(base: UnsafePointer<UInt8>) {
        self.base = base
    }
    
    // MARK: - header fields
    
    /// Major version of the MATH table, = 1.
    public func majorVersion() -> UInt16 {
        readUInt16(base + 0)
    }
    
    /// Minor version of the MATH table, = 0.
    public func minorVersion() -> UInt16 {
        readUInt16(base + 2)
    }
    
    /// Offset to MathConstants table - from the beginning of MATH table.
    public func mathConstantsOffset() -> Offset16 {
        readOffset16(base + 4)
    }
    
    /// Offset to MathGlyphInfo table - from the beginning of MATH table.
    public func mathGlyphInfoOffset() -> Offset16 {
        readOffset16(base + 6)
    }

    /// Offset to MathVariants table - from the beginning of MATH table.
    public func mathVariantsOffset() -> Offset16 {
        readOffset16(base + 8)
    }
    
    // MARK: - sub-tables
    public var mathConstantsTable: MathConstantsTableV2? {
        self._mathConstantsTable
    }
    
    // MARK: - lazy variables
    private lazy var _mathConstantsTable: MathConstantsTableV2? = {
        MathConstantsTableV2(parentBase: self.base, offset: self.mathConstantsOffset())
    }()
}
