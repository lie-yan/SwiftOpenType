import XCTest
@testable import SwiftOpenType

final class MathTableV2Tests: XCTestCase {
    
    func testMathTableHeader() {
        do {
            let helvetica = OTFont(font: CTFontCreateWithName("Helvetica" as CFString, 12, nil))
            XCTAssert(helvetica.mathTable == nil)
        }
        
        do {
            let lmmath = OTFont(font: openFont(path: "fonts/latinmodern-math.otf", size: 12))
            XCTAssert(lmmath.mathTable != nil)
            let mathTable = lmmath.mathTable!
            XCTAssertEqual(mathTable.majorVersion(), 1)
            XCTAssertEqual(mathTable.minorVersion(), 0)
        }
    }
    
    func openFont(path: String, size: CGFloat) -> CTFont {
        let resourcePath = Bundle.module.resourcePath!
        let path = resourcePath + "/" + path
        
        let fileURL = URL(filePath: path)
        let fontDesc = CTFontManagerCreateFontDescriptorsFromURL(fileURL as CFURL) as! [CTFontDescriptor]
        return CTFontCreateWithFontDescriptor(fontDesc[0], size, nil)
    }
}
