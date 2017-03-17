//
//  FlickerImageDataProviderTests.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import XCTest
@testable import FlickerImageAlbum


//! MARK: - Mock network connector
class MockNetworkConnector: NetworkConnector {
    override func request(withUrlString urlString: String, receivedData: @escaping ([AnyHashable: Any]?, Error?) -> Void) {
        let data: [AnyHashable: Any] = [
            "items" : [
                ["media": ["m": "0"]],
                ["media": ["m": "1"]],
                ["media": ["m": "2"]],
            ]]
        receivedData(data, nil)
    }
}


//! MARK: - Main test class
class FlickerImageDataProviderTests: XCTestCase {
    
    private lazy var dataProvider: FlickerImageDataProvider = FlickerImageDataProvider()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testRequest_Success() {
        let asyncExpectation = expectation(description: "wow")
        dataProvider.networkConnector = MockNetworkConnector()
        
        dataProvider.request { (response, success) in
            guard let imageUrls: [String] = response as? [String] else {
                return
            }
            
            guard let success = success else {
                return
            }
            
            assert(success)
            
            for index in 0..<imageUrls.count {
                assert(imageUrls[index] == "\(index)")
            }
            
            asyncExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}


