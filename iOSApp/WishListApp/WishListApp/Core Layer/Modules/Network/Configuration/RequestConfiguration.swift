//
//  RequestConfiguration.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IRequestConfiguration {
    
    func url() -> URLRequest?
    
}


class WishlistRequestConfiguration: IRequestConfiguration {
    
    func url() -> URLRequest? {
        let request = WishlistRequest.init(apiKey: "")
        return request.urlRequest
    }
    
}
