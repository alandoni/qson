//
//  JsonConvertibleObject.swift
//  ZapCar
//
//  Created by Alan Quintiliano on 04/06/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonConvertibleObject : JsonConvertible {
    var value : NSDictionary!;// [String: JsonConvertible?]!;
    var type : NSString?;

    init(value : NSDictionary) {
        self.value = value;
        self.type = getNameOFClassOfObject();
    }
    
    func getNameOFClassOfObject() -> NSString! {
        //return NSStringFromClass(value.dynamicType).componentsSeparatedByString(".").last!
        return "";
    }

    func getValue() -> AnyObject? {
        return self.value as AnyObject
    }
}