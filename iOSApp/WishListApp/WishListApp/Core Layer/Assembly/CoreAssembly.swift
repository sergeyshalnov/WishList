//
//  CoreAssembly.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol ICoreAssembly {
    
    func getRequest() -> IGetRequest
    func requestParser() -> RequestParser
    
}


class CoreAssembly: ICoreAssembly {
    
    func getRequest() -> IGetRequest {
        return GetRequest(config: WishlistRequestConfiguration())
    }
    
    func requestParser() -> RequestParser {
        return RequestParser()
    }
    
}
