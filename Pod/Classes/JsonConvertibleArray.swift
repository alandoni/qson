//
//  JsonConvertibleArray.swift
//  ZapCar
//
//  Created by Alan Quintiliano on 04/06/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonConvertibleArray : JsonConvertible {
    var value : NSMutableArray!;
    var type : NSString?;
    
    init() {
        value = NSMutableArray()
    }
    
    func getValue() -> AnyObject? {
        return value as AnyObject
    }
    
    func append(value : JsonConvertible?) {
        self.value.addObject(value as! AnyObject)
    }
}