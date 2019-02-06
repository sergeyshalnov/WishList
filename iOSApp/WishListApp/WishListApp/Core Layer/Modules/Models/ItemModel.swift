//
//  ItemModel.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


struct ItemModel: Codable {
    
    var id: Int
    var name: String
    var comment: String
    var cost: Int
    var url: String
    
    init(id: Int, name: String, comment: String, cost: Int, url: String) {
        self.id = id
        self.name = name
        self.comment = comment
        self.cost = cost
        self.url = url
    }

}

struct OneItemResponseModel: Codable {
    
    let status: String
    let data: ItemModel
    
}

struct WishlistResponseModel: Codable {
    
    let status: String
    let data: [ItemModel]
    
}
