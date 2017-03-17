//
//  ImagePreFetcherProtocol.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import Foundation

protocol ImagePreFetcherProtocol {
    func setup(imageUrls: [String])
    
    func nextImageData(withCompletion complete: @escaping (Data?) -> Void)
}
