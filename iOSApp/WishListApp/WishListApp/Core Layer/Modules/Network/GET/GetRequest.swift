//
//  GetRequest.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class GetRequest: IGetRequest {
    
    private var task: URLSessionDataTask?
    private let config: IRequestConfiguration
    
    init(config: IRequestConfiguration) {
        self.config = config
    }
    
    func request(completion: @escaping (Data?) -> Void) {
        guard let url = config.url() else { return }
        
        let session = URLSession.shared
        
        task = session.dataTask(with: url) { (data, response, error) in
            completion(error != nil ? nil : data)
        }
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
