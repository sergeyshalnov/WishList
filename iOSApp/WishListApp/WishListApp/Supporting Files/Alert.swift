//
//  Alert.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 05/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import UIKit


// MARK: - Alerts for non-escaping completion

class Alert {
    
    enum Message: String {
        case saveError = "Item not saved"
        case deleteError = "Item not delete"
        case costError = "Field \"cost\" is filled with incorrect data"
        case responseItemError = "The save was successful, but no response was received from the server"
    }
    
    static func controller(type: Alert.Message,
                           message: MessageModel? = nil,
                           left: ((UIAlertAction) -> Void)? = nil) -> UIAlertController{
        let title: String = "Error"
        let text: String = message?.message ?? type.rawValue
        
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: left))
        
        return alert
    }
    
}
