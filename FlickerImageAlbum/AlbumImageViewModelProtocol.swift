//
//  AlbumImageViewModelProtocol.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import Foundation

protocol AlbumImageViewModelDelegate: class {
    func didImageUrlsChanged()
}

protocol AlbumImageViewModelProtocol {
    
    //! MARK: - Output
    
    weak var delegate: AlbumImageViewModelDelegate? { get set }
    
    
    //! MARK: - Needed Modules
    
    var networkAgent: NetworkAgentProtocol? { get }
    var imagePreFetcher: ImagePreFetcherProtocol? { get }
    
    
    //! MARK: - Interface
    
    func prepareForUse(withComplete complete: @escaping (Bool) -> Void)

    func nextImageData(withCompletion complete: @escaping (Data?) -> Void)
}
