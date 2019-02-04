//
//  WishlistManager.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


class WishlistManager: IWishlistManager {
    
    // MARK: - Private variables
    
    private let getRequest: IGetRequest
    private let requestParser: RequestParser
    
    private var temporaryItemsArray: [ItemModel] = []
    
    
    // MARK: - Initialization
    
    init(getRequest: IGetRequest, requestParser: RequestParser) {
        self.getRequest = getRequest
        self.requestParser = requestParser
    }
    
    
    // MARK: - Main funcionality
    
    func performeRequest(completion: ((Int) -> (Void))?) {
        
        getRequest.request(completion: { (data) in
            guard let data = data else { return }
            guard let items = self.requestParser.parse(data: data) else { return }
            
            self.temporaryItemsArray = items
            
            completion?(items.count)
        })
        
    }
    
    func getItem(index: Int) -> ItemModel {
        return temporaryItemsArray[index]
    }
    
}
