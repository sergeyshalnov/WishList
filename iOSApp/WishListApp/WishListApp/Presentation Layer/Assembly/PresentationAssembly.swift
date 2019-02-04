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
    func Item(item: ItemModel, mode: ViewMode) -> ItemViewController
    
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServiceAssembly
    
    
    // MARK: - Initialization
    
    init(serviceAssembly: IServiceAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    
    // MARK: - Main Funcionality
    
    func ItemsList() -> UINavigationController {
        let controller = ItemsListViewController(presentationAssembly: self, wishlistManager: serviceAssembly.itemsManager())
        let navigationController = UINavigationController()
        
        navigationController.viewControllers = [controller]
        
        return navigationController
    }
    
    func Item(item: ItemModel, mode: ViewMode) -> ItemViewController {
        let controller = ItemViewController(item: item, wishlistManager: serviceAssembly.itemsManager(), mode: mode)
        
        return controller
    }
    
}
