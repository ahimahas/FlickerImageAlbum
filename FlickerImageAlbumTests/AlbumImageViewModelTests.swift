//
//  AlbumImageViewModelTests.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import XCTest
@testable import FlickerImageAlbum

//! MARK: - Mock network class
class MockNetworkAgent: NetworkAgentProtocol {
    var urlString: String = ""
    var networkConnector: NetworkConnector = NetworkConnector()
    
    func request(withCompletion complete: @escaping (Any?, Bool?) -> Void) {
        let dummyValues: [String] = ["url1", "url2"]
        complete(dummyValues, true)
    }
}

class MockNetworkAgentReturnFail: NetworkAgentProtocol {
    var urlString: String = ""
    var networkConnector: NetworkConnector = NetworkConnector()
    
    func request(withCompletion complete: @escaping (Any?, Bool?) -> Void) {
        complete(nil, false)
    }
}

class MockNetworkAgentReturnNil: NetworkAgentProtocol {
    var urlString: String = ""
    var networkConnector: NetworkConnector = NetworkConnector()
    
    func request(withCompletion complete: @escaping (Any?, Bool?) -> Void) {
        complete(nil, true)
    }
}


//! MARK: - Mock ImagePreFetcher
class MockImagePreFetcher: ImagePreFetcherProtocol {
    static let dummyData: Data = "dummyData".data(using: .utf8)!
    
    func setup(imageUrls: [String]) {
        
    }
    
    func nextImageData(withCompletion complete: @escaping (Data?) -> Void) {
        complete(MockImagePreFetcher.dummyData)
    }
}


//! MARK: - Mock delegate class
class MockDelegateProcessor: AlbumImageViewModelDelegate {
    public var isReceviedDelegate: Bool = false

    func didImageUrlsChanged() {
        isReceviedDelegate = true
    }
}


//! MARK: - Main Test class
class AlbumImageViewModelTests: XCTestCase {
    
    private var viewModel: AlbumImageViewModel?
    private lazy var mockDelegateProcessor: MockDelegateProcessor = MockDelegateProcessor()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        viewModel?.delegate = nil
        viewModel = nil
    }
    
    func testPrepareForUse_Success() {
        viewModel = AlbumImageViewModel(networkAgent: MockNetworkAgent(), imageFetcher: MockImagePreFetcher())
        viewModel?.delegate = mockDelegateProcessor
        
        viewModel?.prepareForUse(withComplete: { (success) in
            assert(success)
            assert(self.mockDelegateProcessor.isReceviedDelegate)
        })
    }
    
    func testPrepareForUse_Fail() {
        viewModel = AlbumImageViewModel(networkAgent: MockNetworkAgentReturnFail(), imageFetcher: MockImagePreFetcher())
        viewModel?.delegate = mockDelegateProcessor
        
        viewModel?.prepareForUse(withComplete: { (success) in
            assert(success == false)
            assert(self.mockDelegateProcessor.isReceviedDelegate == false)
        })
    }
    
    func testPrepareForUse_ReturnNil() {
        viewModel = AlbumImageViewModel(networkAgent: MockNetworkAgentReturnNil(), imageFetcher: MockImagePreFetcher())
        viewModel?.delegate = mockDelegateProcessor
        
        viewModel?.prepareForUse(withComplete: { (success) in
            assert(success == false)
            assert(self.mockDelegateProcessor.isReceviedDelegate == false)
        })
    }
    
    func testNextImageData() {
        viewModel = AlbumImageViewModel(networkAgent: MockNetworkAgent(), imageFetcher: MockImagePreFetcher())
        viewModel?.delegate = mockDelegateProcessor
        
        viewModel?.nextImageData(withCompletion: { (data) in
            let naData: NSData = data! as NSData
            assert(naData.isEqual(to: MockImagePreFetcher.dummyData))
        })
    }
    
}
