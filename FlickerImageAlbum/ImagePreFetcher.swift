//
//  ImagePreFetcher.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import Foundation

final class ImagePreFetcher: ImagePreFetcherProtocol {
    
    lazy private var imageUrls: [String] = []
    lazy private var imageCache: NSCache = NSCache<NSString, NSData>()
    lazy private var currentImageIndex: Int = 0
    
    
    //!: MARK: - Interface
    
    func setup(imageUrls: [String]) {
        self.imageUrls = imageUrls
        preFetchImage(atIndex: currentImageIndex, withCompletion: nil)
        preFetchImage(atIndex: nextImageIndex(), withCompletion: nil)
    }
    
    
    func nextImageData(withCompletion complete: @escaping (Data?) -> Void) {
        let imageUrlString: String = imageUrls[currentImageIndex]
        
        if let cachedData: NSData = imageCache.object(forKey: imageUrlString as NSString) {
            complete(cachedData as Data)
            currentImageIndex = nextImageIndex()
            preFetchImage(atIndex: currentImageIndex, withCompletion: nil)
            return
        }
        
        preFetchImage(atIndex: currentImageIndex, withCompletion: { [weak self] (data) in
            guard let `self` = self else {
                complete(nil)
                return
            }
            
            complete(data)
            self.currentImageIndex = self.nextImageIndex()
        })
        
        preFetchImage(atIndex: nextImageIndex(), withCompletion: nil)
    }
    
    
    //!: MARK: - Private Methods
    
    private final func preFetchImage(atIndex index: Int, withCompletion complete: ((Data?) -> Void)?) {
        if index >= imageUrls.count {
            return
        }
        
        let imageUrlString: String = imageUrls[index]
        retreiveImageData(atUrlString: imageUrlString, withCompletion: { [weak self] (data) in
            guard let data = data else {
                complete?(nil)
                return
            }
            
            guard let `self` = self else {
                complete?(nil)
                return
            }
            
            self.imageCache.setObject(data as NSData, forKey: imageUrlString as NSString)
            
            complete?(data)
        })
        
    }
    
    private final func retreiveImageData(atUrlString imageUrlString: String, withCompletion complete: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            guard let url: URL = URL(string: imageUrlString) else {
                print("[ImagePreFetcher Error] urlString is invalid")
                DispatchQueue.main.async {
                    complete(nil)
                }
                return
            }
            
            guard let data: Data = try? Data(contentsOf: url) else {
                print("[ImagePreFetcher Error] retreiving image data is failed")
                DispatchQueue.main.async {
                    complete(nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                complete(data)
            }
        }
    }
    
    private final func nextImageIndex() -> Int {
        return currentImageIndex + 1 >= imageUrls.count ? 0 : currentImageIndex + 1
    }
}

