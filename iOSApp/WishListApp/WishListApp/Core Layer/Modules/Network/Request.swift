//
//  Request.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class WishlistRequest: IRequest {
    
    // MARK: - Private variables
    
    private let baseUrl: String = "http://127.0.0.1"
    private let prefix: String = "api/Item"
    private let apiKey: String
    private var port: String = ":"
    
    // MARK: - Calculated variables
    
    private var url: String {
        print(baseUrl + port + "/" + prefix)
        return baseUrl + port + "/" + prefix
    }
    
    var urlRequest: URLRequest? {
        if let url = URL(string: url) {
            return URLRequest(url: url)
        }
        
        return nil
    }
    
    
    // MARK: - Initializaition
    
    init(apiKey: String, port: String = "5000") {
        self.port += port
        self.apiKey = apiKey
    }
    

}
