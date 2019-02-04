//
//  ItemModel.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


struct ItemModel: Codable {
    
    let id: Int
    let name: String
    let comment: String
    let cost: Int
    let url: String

}

struct WishlistResponseModel: Codable {
    
    let status: String
    let data: [ItemModel]
    
}
