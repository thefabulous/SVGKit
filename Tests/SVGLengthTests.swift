import ObjectiveC
import SVGKit
import XCTest

final class SVGLengthTests: XCTestCase {
    func testKnownIPhonePPI() {
        XCTAssertEqual(pixelsPerInch(for: "iPhone18,1"), 460, accuracy: 0.001)
    }

    func testUnknownIPhoneUsesFallbackWithoutThrowing() {
        XCTAssertEqual(pixelsPerInch(for: "iPhone99,1"), 401, accuracy: 0.001)
    }

    private func pixelsPerInch(for platform: String) -> Float {
        let selector = NSSelectorFromString("pixelsPerInchForPlatform:")
        guard let method = class_getClassMethod(SVGLength.self, selector) else {
            XCTFail("Missing pixelsPerInchForPlatform:")
            return 0
        }

        typealias PixelsPerInchFunction = @convention(c) (AnyObject, Selector, NSString) -> Float
        let function = unsafeBitCast(method_getImplementation(method), to: PixelsPerInchFunction.self)
        return function(SVGLength.self, selector, platform as NSString)
    }
}
