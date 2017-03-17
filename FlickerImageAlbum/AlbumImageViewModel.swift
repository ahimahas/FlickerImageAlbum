//
//  AlbumImageViewModel.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import Foundation

final class AlbumImageViewModel: AlbumImageViewModelProtocol {
    
    var delegate: AlbumImageViewModelDelegate?
    private(set) var networkAgent: NetworkAgentProtocol?
    private(set) var imagePreFetcher: ImagePreFetcherProtocol?
    
    
    //! MARK: - Initializer
    
    init(networkAgent: NetworkAgentProtocol, imageFetcher: ImagePreFetcherProtocol) {
        self.networkAgent = networkAgent
        self.imagePreFetcher = imageFetcher
    }
    
    
    //! MARK: - AlbumImageViewModelProtocol Imp
    
    func prepareForUse(withComplete complete: @escaping (Bool) -> Void) {
        
        networkAgent?.request(withCompletion: { [weak self] (imageUrls, success) in
            if success == false {
                complete(false)
                return
            }
            
            guard let imageUrls = imageUrls as? [String] else {
                complete(false)
                return
            }
            
            guard let `self` = self else {
                complete(false)
                return
            }
            
            self.imagePreFetcher?.setup(imageUrls: imageUrls)
            self.delegate?.didImageUrlsChanged()
            
            complete(true)
        })
    }
    
    func nextImageData(withCompletion complete: @escaping (Data?) -> Void) {
        imagePreFetcher?.nextImageData(withCompletion: { (data) in
            complete(data)
        })
    }
}


