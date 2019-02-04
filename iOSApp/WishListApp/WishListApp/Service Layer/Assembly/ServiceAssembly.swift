//
//  ServiceAssembly.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IServiceAssembly {
    
    func itemsManager() -> IWishlistManager
    
}


class ServiceAssembly: IServiceAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    func itemsManager() -> IWishlistManager {
        return WishlistManager(getRequest: coreAssembly.getRequest(), deleteRequest: coreAssembly.deleteRequest(), requestParser: coreAssembly.requestParser())
    }
    
}
