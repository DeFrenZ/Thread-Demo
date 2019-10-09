import XCTest

final class AppUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }
}

// MARK: Tests
extension AppUITests {
    func testPerfomance_launch() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
