//
//  BitcoinsFakeTests.swift
//  BitcoinsTests
//
//  Created by SukPoet on 2022/10/23.
//

import XCTest
@testable import Bitcoins

final class BitcoinsFakeTests: XCTestCase {

    var sut: ViewController!
    let networkMonitor = BTCNetworkMonitor.shared
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "BitcoinHome") as? ViewController
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testDataFromApiRequest() throws {
        try XCTSkipUnless(sut != nil, "The home page ViewController is nil")
        try XCTSkipUnless(networkMonitor.isReachable, "Network connectivity needed for this test.")
        // given
        let fakeData = "{\"time\":{\"updated\":\"Oct 23, 2022 09:49:00 UTC\",\"updatedISO\":\"2022-10-23T09:49:00+00:00\",\"updateduk\":\"Oct 23, 2022 at 10:49 BST\"},\"disclaimer\":\"This data was produced from the CoinDesk Bitcoin Price Index (USD). Non-USD currency data converted using hourly conversion rate from openexchangerates.org\",\"chartName\":\"Bitcoin\",\"bpi\":{\"USD\":{\"code\":\"USD\",\"symbol\":\"$\",\"rate\":\"19,183.4209\",\"description\":\"United States Dollar\",\"rate_float\":19183.4209},\"GBP\":{\"code\":\"GBP\",\"symbol\":\"£\",\"rate\":\"16,029.5131\",\"description\":\"British Pound Sterling\",\"rate_float\":16029.5131},\"EUR\":{\"code\":\"EUR\",\"symbol\":\"€\",\"rate\":\"18,687.4528\",\"description\":\"Euro\",\"rate_float\":18687.4528}}}".data(using: .utf8)
        let urlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
        let url = URL(string: urlString)!
        let fakeResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let urlSessionFake = BTCURLSessionMock(data: fakeData, response: fakeResponse, error: nil)
        sut.urlSession = urlSessionFake
        let promise = expectation(description: "Value Received")
        // when
        sut.request {_ in
            // then
            XCTAssertEqual(self.sut.updatedRate?.gbp?.rate_float ?? 0.0, 16029.5131, accuracy: 0.0001) //Floating point numbers should not be compared for equality. Instead, we should verify that they are almost equal by using some error bound
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
}
