//
//  BitcoinsTests.swift
//  BitcoinsTests
//
//  Created by SukPoet on 2022/10/20.
//

import XCTest

@testable import Bitcoins

final class BitcoinsTests: XCTestCase {
    var sut: URLSession!
    let networkMonitor = BTCNetworkMonitor.shared
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = URLSession(configuration: .default)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    //Asynchronous test: this test checks that sending a valid request returns a 200 status code within 5 seconds
    func testValidApiCallGetsHTTPStatusCode200() throws {
        try XCTSkipUnless(networkMonitor.isReachable, "Network connectivity needed for this test.")
        // given
        let urlString = "https://api.coindesk.com/v1/bpi/currentprice.json"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Status code: 200")
        // when
        let dataTask = sut.dataTask(with: url) { _, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
    }
}
