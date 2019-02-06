//
//  IGetRequest.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IGetRequest {
    
    func request(completion: @escaping (Data?) -> Void)
    func cancel()
    
}
