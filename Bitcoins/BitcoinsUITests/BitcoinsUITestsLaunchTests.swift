//
//  BitcoinsUITestsLaunchTests.swift
//  BitcoinsUITests
//
//  Created by SukPoet on 2022/10/20.
//

import XCTest
/**
 I tried to write UI test, but everytime I click the red record button at the bottom of the editor window to record my interactions as test commands, the test crashes. Xcode reports an error infomation as bellow:
 Thread 1: "[<_UINavigationBarContentViewLayout 0x7f8954f20830> valueForUndefinedKey:]: this class is not key value coding-compliant for the key inlineTitleView."
 I googled it. I found that it is a common issue on Xcode 14. https://developer.apple.com/forums/thread/712240
 
 https://stackoverflow.com/questions/73350251/xcode-14-beta-5-throws-an-exception
 This is a bug in Xcode 14. Other users have reported it here: https://developer.apple.com/forums/thread/712240
 Initially, the issue was reported in Xcode 14 betas, but the bug was never fixed, and now, here we are. I reproduce the issue in the official release of Xcode 14.0.1. */
final class BitcoinsUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
