//
//  RequestParser.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class RequestParser: IRequestParser {
    typealias Models = [ItemModel]
    typealias Model = ItemModel
    
    func parseAll(data: Data) -> [ItemModel]? {
        do {
            let wishlist = try JSONDecoder().decode(WishlistResponseModel.self, from: data)
            return wishlist.data
        } catch {
            return nil
        }
    }
    
    func parse(data:Data) -> ItemModel? {
        do {
            let item = try JSONDecoder().decode(OneItemResponseModel.self, from: data)
            return item.data
        } catch {
            return nil
        }
    }
    
}
