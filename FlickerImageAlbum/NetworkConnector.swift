//
//  NetworkConnector.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import Foundation

class NetworkConnector {
    func request(withUrlString urlString: String, receivedData: @escaping ([AnyHashable: Any]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("[NetworkConnector Error] session responses with error: \(error!)")
                DispatchQueue.main.async {
                    receivedData(nil, error)
                }
                return
            }
            
            guard let data = data else {
                print("[NetworkConnector Error] data is empty")
                DispatchQueue.main.async {
                    receivedData(nil, error)
                }
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) {
                if let jsonDict = json as? [AnyHashable: Any] {
                    DispatchQueue.main.async {
                        receivedData(jsonDict, nil)
                    }
                    return
                }
            }
            
            print("[NetworkConnector Error] JSON parse failed")
            DispatchQueue.main.async {
                receivedData(nil, error)
            }
        }
        
        task.resume()
    }
}
