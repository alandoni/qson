//
//  JsonArray.swift
//  ZapCar
//
//  Created by Alan Quintiliano on 01/06/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonArray {
    let array : NSArray
    
    init(array : NSArray) {
        self.array = array
    }
    
    func toString(qson : Qson) -> String {
        var text = "["
        for (index,obj) in enumerate(self.array) {
            text += "\(qson.toJson(obj as! NSObject))"
            
            if (index < array.count - 1) {
                text += ","
            }
            if (index == array.count - 1) {
                text += "]"
            }
        }
        return text
    }
}