//
//  FlickerImageDataProvider.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import Foundation


final class FlickerImageDataProvider: NetworkAgentProtocol {
    var urlString: String = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1"
    var networkConnector: NetworkConnector = NetworkConnector()
    
    //! MARK: - NetworkAgentProtocol Imp
    func request(withCompletion complete: @escaping (Any?, Bool?) -> Void) {

        networkConnector.request(withUrlString: urlString) { (receivedData, error) in
            guard error == nil else {
                complete(nil, false)
                return
            }
            
            guard let receivedData = receivedData else {
                print("[FlickerImageDataProvider Error] receivedData is nil")
                complete(nil, false)
                return
            }
            
            guard let items: [Any] = receivedData["items"] as? [Any] else {
                print("[FlickerImageDataProvider Error] receivedData doesn't has items")
                complete(nil, false)
                return
            }
            
            var mediaUrls: [String] = []
            for item in items {
                guard var item = item as? [String: Any] else {
                    continue
                }
                
                guard let media = item["media"] as? [String: Any] else {
                    continue
                }
                
                guard let mediaUrl = media["m"] as? String else {
                    continue
                }
                
                mediaUrls.append(mediaUrl)
            }
            
            complete(mediaUrls, true)
        }
    }
}
