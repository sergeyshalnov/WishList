//
//  PutRequest.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class PutRequest: IPutRequest {
    
    private var task: URLSessionDataTask?
    private let config: IRequestConfiguration
    
    init(config: IRequestConfiguration) {
        self.config = config
    }
    
    func request(model: ItemModel, completion: @escaping (Bool) -> Void) {
        guard var request = config.url() else { return }
        
        let session = URLSession.shared
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(model) else {
            completion(false)
            return
        }
        
        request.httpBody = httpBody
        
        task = session.dataTask(with: request) { (data, response, error) in
            completion(error == nil)
        }
        
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
