//
//  JsonObject.swift
//  ZapCar
//
//  Created by Alan Quintiliano on 01/06/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonObject {
    let object : JsonParseable
    
    init(object : JsonParseable) {
        self.object = object
    }
    
    func toString(qson: Qson) -> String {
        let reflectObject = reflect(self.object)
        var text = "{"
        
        let count = reflectObject.count-1
        for i in 1...count {
            
            let obj : Any = reflectObject[i].1.value
            let unwrapped = JsonObject.unwrap(obj)
            
            let jsonElement = JsonElement(name: reflectObject[i].0, value: unwrapped, valueType:JsonElement.getTypeOfValue(unwrapped))
            let map = jsonElement.toString(qson)
            
            if (i > 1 && map != "") {
                text += ","
            }
            
            text += map
        }
        text += "}"
        return text
    }
    
    static func unwrap(any:Any) -> Any? {
        let mi:MirrorType = reflect(any)
        if mi.disposition != .Optional {
            return any
        }
        if mi.count == 0 { return nil } // Optional.None
        let (name,some) = mi[0]
        return some.value
    }
}