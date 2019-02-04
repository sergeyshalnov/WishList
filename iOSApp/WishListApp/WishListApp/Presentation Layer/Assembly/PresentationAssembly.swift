//
//  PresentationAssembly.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit


protocol IPresentationAssembly {
    
    func ItemsList() -> UINavigationController
    
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
    
    
    // MARK: - Initialization
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    
    // MARK: - Main Funcionality
    
    func ItemsList() -> UINavigationController {
        let controller = ItemsListViewController(wishlistManager: serviceAssembly.itemsManager())
        let navigationController = UINavigationController()
        
        navigationController.viewControllers = [controller]
        
        return navigationController
    }
    
}
