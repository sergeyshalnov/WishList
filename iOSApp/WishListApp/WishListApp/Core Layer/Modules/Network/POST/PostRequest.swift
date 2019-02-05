//
//  PostRequest.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class PostRequest: RequestTemplate, IPostRequest {
    
    override var httpMethod: String {
        return "POST"
    }
    
}
