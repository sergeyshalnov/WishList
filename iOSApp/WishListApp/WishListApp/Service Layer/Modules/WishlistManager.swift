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
    private let postRequest: IPostRequest
    private let putRequest: IPutRequest
    private let deleteRequest: IDeleteRequest
    private let requestParser: RequestParser
    
    private var temporaryItemsArray: [ItemModel] = []
    
    
    // MARK: - Initialization
    
    init(getRequest: IGetRequest, postRequest: IPostRequest, putRequest: IPutRequest, deleteRequest: IDeleteRequest, requestParser: RequestParser) {
        self.getRequest = getRequest
        self.postRequest = postRequest
        self.putRequest = putRequest
        self.deleteRequest = deleteRequest
        self.requestParser = requestParser
    }
    
    
    // MARK: - Main funcionality
    
    func performeRequest(completion: ((Int) -> (Void))?) {
        
        getRequest.request(completion: { (data) in
            guard let data = data else { return }
            guard let items = self.requestParser.parseAll(data: data) else { return }
            
            self.temporaryItemsArray = items
            
            completion?(items.count)
        })
        
    }
    
    func getItem(id: Int) -> ItemModel? {
        let item = temporaryItemsArray.filter({ $0.id == id }).first
        
        return item
    }
    
    func getItem(index: Int) -> ItemModel {
        return temporaryItemsArray[index]
    }
    
    func addItem(item: ItemModel, completion: @escaping (Bool, MessageModel?, ItemModel?) -> Void) {
        
        postRequest.request(model: item) { (success, message, data) in
            var item: ItemModel? = nil
            
            if let data = data {
                item = self.requestParser.parse(data: data)
            }
            
            completion(success, message, item)
        }
        
    }
    
    func editItem(item: ItemModel, completion: @escaping (Bool, MessageModel?, ItemModel?) -> Void) {
        
        putRequest.request(model: item) { (success, message, data) in
            var item: ItemModel? = nil
            
            if let data = data {                
                item = self.requestParser.parse(data: data)
            }
            
            completion(success, message, item)
        }
        
    }
    
    func deleteItem(index: Int, completion: @escaping (Bool) -> Void) {
        
        if !temporaryItemsArray.indices.contains(index) {
            completion(false)
            return
        }
        
        deleteRequest.request(model: temporaryItemsArray[index]) { (success) in
            completion(success)
        }
        
    }
    
    func deleteItem(id: Int, completion: @escaping (Bool) -> Void) {
        
        guard let item = temporaryItemsArray.filter({ $0.id == id }).first else {
            completion(false)
            return
        }
        
        temporaryItemsArray = temporaryItemsArray.filter({ $0.id != id })
        
        deleteRequest.request(model: item) { (success) in
            completion(success)
        }
        
    }
    
}
