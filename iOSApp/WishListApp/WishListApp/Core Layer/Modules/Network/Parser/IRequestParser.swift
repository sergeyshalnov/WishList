//
//  IRequestParser.swift
//  WishListApp
//
//  Created by Sergey Shalnov on 04/02/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation


protocol IRequestParser {
    associatedtype Models
    associatedtype Model
    
    func parseAll(data: Data) -> Models?
    func parse(data: Data) -> Model?
    
}
