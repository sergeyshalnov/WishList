//
//  RequestTemplate.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 05/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class RequestTemplate {
    
    private var task: URLSessionDataTask?
    private let config: IRequestConfiguration
    
    var httpMethod: String {
        return ""
    }
    
    init(config: IRequestConfiguration) {
        self.config = config
    }
    
    func request(model: ItemModel, completion: @escaping (Bool, MessageModel?) -> Void) {
        guard var request = config.url() else { return }
        
        let session = URLSession.shared
        
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONEncoder().encode(model) else {
            completion(false, nil)
            return
        }
        
        request.httpBody = httpBody
        
        task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, nil)
                return
            }
            
            if httpResponse.statusCode == 400 {
                let message = try? JSONDecoder().decode(MessageModel.self, from: data)
                completion(false, message)
            } else {
                completion(error == nil, nil)
            }
        }
        
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}

