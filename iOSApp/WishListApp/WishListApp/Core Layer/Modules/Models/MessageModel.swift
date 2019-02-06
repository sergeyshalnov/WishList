//
//  MessageModel.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 05/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


struct MessageModel: Codable {
    
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
}
