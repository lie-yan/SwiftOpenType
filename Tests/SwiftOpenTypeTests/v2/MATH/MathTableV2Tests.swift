import XCTest
@testable import SwiftOpenType

final class MathTableV2Tests: XCTestCase {
    
    func testMathTableHeader() {
        let helvetica = CTFontCreateWithName("Helvetica" as CFString, 12, nil)
        XCTAssert(OTFont(font: helvetica).mathTable == nil)
        
        let lmmath = openOTFont(path: "fonts/latinmodern-math.otf")
        XCTAssert(lmmath.mathTable != nil)
        
        let mathTable = lmmath.mathTable!
        XCTAssertEqual(mathTable.majorVersion(), 1)
        XCTAssertEqual(mathTable.minorVersion(), 0)
    }
    
    private func openOTFont(path: String) -> OTFont {
        OTFont(font: openFont(path: path, size: 12.0))
    }
    
    func openFont(path: String, size: CGFloat) -> CTFont {
        let resourcePath = Bundle.module.resourcePath!
        let path = resourcePath + "/" + path
        
        let fileURL = URL(filePath: path)
        let fontDesc = CTFontManagerCreateFontDescriptorsFromURL(fileURL as CFURL) as! [CTFontDescriptor]
        return CTFontCreateWithFontDescriptor(fontDesc[0], size, nil)
    }
}
