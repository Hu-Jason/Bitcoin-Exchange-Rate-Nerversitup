//
//  BTCURLSessionMockTest.swift
//  Bitcoins
//
//  Created by SukPoet on 2022/10/23.
//

import Foundation

protocol BTCURLSessionMockProtocol {
    func dataTask(
        with url: URL,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: BTCURLSessionMockProtocol {}

class BTCURLSessionMock: BTCURLSessionMockProtocol {
    private let mockData: Data?
    private let mockResponse: URLResponse?
    private let mockError: Error?
    
    public init(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.mockData = data
        self.mockResponse = response
        self.mockError = error
    }
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        BTCURLSessionDataTaskMock(mockData: mockData, mockResponse: mockResponse, mockError: mockError, completionHandler: completionHandler)
    }
}

class BTCURLSessionDataTaskMock: URLSessionDataTask {
    private let mockData: Data?
    private let mockResponse: URLResponse?
    private let mockError: Error?
    private let completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(mockData: Data? = nil, mockResponse: URLResponse? = nil, mockError: Error? = nil, completionHandler: ((Data?, URLResponse?, Error?) -> Void)? = nil) {
        self.mockData = mockData
        self.mockResponse = mockResponse
        self.mockError = mockError
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler?(mockData, mockResponse, mockError)
    }
}
