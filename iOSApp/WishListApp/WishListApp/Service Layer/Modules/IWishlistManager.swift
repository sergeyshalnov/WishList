//
//  IWishlistManager.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IWishlistManager {
    
    func performeRequest(completion: ((Int) -> (Void))?)
    func getItem(index: Int) -> ItemModel
    func addItem(item: ItemModel, completion: @escaping (Bool) -> Void) 
    func editItem(item: ItemModel, completion: @escaping (Bool) -> Void) 
    func deleteItem(index: Int, completion: @escaping (Bool) -> Void)
    
}
