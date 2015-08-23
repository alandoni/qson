//
//  JsonConvertibleSimpleObject.swift
//  QsonTest
//
//  Created by Alan Quintiliano on 16/08/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonConvertibleSimpleObject : JsonConvertible {
 
    let value : NSObject?;
    
    init(value : NSObject?) {
        self.value = value;
    }
    
    func getValue() -> AnyObject? {
        return value;
    }
}