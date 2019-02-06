//
//  IPutRequest.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IPutRequest {
    
    func request(model: ItemModel, completion: @escaping (Bool, MessageModel?, Data?) -> Void) 
    func cancel()
    
}
