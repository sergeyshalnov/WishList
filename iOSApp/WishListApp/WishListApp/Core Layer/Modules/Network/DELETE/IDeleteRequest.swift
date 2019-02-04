//
//  IDeleteRequest.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IDeleteRequest {
    
    func request(model: ItemModel, completion: @escaping (Bool) -> Void)
    func cancel() 
    
}
