//
//  JsonElement.swift
//  ZapCar
//
//  Created by Alan Quintiliano on 01/06/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonElement {
    let name: String
    let value: Any
    let valueType: JsonTypesOfObjects
    
    init(name:String, value:Any, valueType : JsonTypesOfObjects) {
        self.name = name
        self.value = value
        self.valueType = valueType
    }
    
    func toString(jsonKit : Qson) -> String {
        let object = jsonKit.toJson(value)
        if ((object as? String) == "null") {
            return ""
        }
        return "\"\(name)\":\(object)"
    }
    
    static func getTypeOfValue(obj:Any) -> JsonTypesOfObjects {
        let value = JsonObject.unwrap(obj)
        if let array = value as? NSArray {
            return JsonTypesOfObjects.Array
        } else if let str = value as? String {
            return JsonTypesOfObjects.String
        } else if let int = value as? Int {
            return JsonTypesOfObjects.Int
        } else if let bool = value as? Bool {
            return JsonTypesOfObjects.Boolean
        } else if let double = value as? Double {
            return JsonTypesOfObjects.Float
        } else if let float = value as? Float {
            return JsonTypesOfObjects.Float
        }
        return JsonTypesOfObjects.Object
    }
}