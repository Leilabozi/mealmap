import Foundation
import XCTest
@testable import MealMap

final class RecipeAPIErrorTests: XCTestCase {
    func testOfflineAndTimeoutMessagesAreReadable() {
        XCTAssertEqual(
            RecipeAPIError.from(urlError: URLError(.notConnectedToInternet)),
            .offline
        )
        XCTAssertEqual(
            RecipeAPIError.from(urlError: URLError(.timedOut)),
            .timedOut
        )
        XCTAssertFalse(RecipeAPIError.offline.userMessage.contains("NSURL"))
        XCTAssertFalse(RecipeAPIError.requestFailed.userMessage.contains("URLSession"))
    }
}
