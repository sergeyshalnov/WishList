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
    func postRequest() -> IPostRequest
    func putRequest() -> IPutRequest
    func deleteRequest() -> IDeleteRequest
    func requestParser() -> RequestParser
    
}


class CoreAssembly: ICoreAssembly {
    
    func getRequest() -> IGetRequest {
        return GetRequest(config: WishlistRequestConfiguration())
    }
    
    func postRequest() -> IPostRequest {
        return PostRequest(config: WishlistRequestConfiguration())
    }
    
    func putRequest() -> IPutRequest {
        return PutRequest(config: WishlistRequestConfiguration())
    }
    
    func deleteRequest() -> IDeleteRequest {
        return DeleteRequest(config: WishlistRequestConfiguration())
    }
    
    func requestParser() -> RequestParser {
        return RequestParser()
    }
    
}
