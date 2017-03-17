//
//  NetworkAgentProtocol.swift
//  FlickerImageAlbum
//
//  Created by 창우김 on 2017. 3. 17..
//  Copyright © 2017년 Changwoo, Kim. All rights reserved.
//

import Foundation

protocol NetworkAgentProtocol {
    var urlString: String { get }
    
    var networkConnector: NetworkConnector { get set }
    
    func request(withCompletion complete: @escaping (Any?, Bool?) -> Void)
}
