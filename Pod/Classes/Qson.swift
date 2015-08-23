//
//  JsonKit.swift
//  JsonKit
//
//  Created by Alan Quintiliano on 28/05/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import UIKit
import Foundation

class Qson {
    
    func toJson(object : Any) -> String {
        let objectToSerialize = JsonObject.unwrap(object)
        
        if (objectToSerialize == nil) {
            return "null"
        }
        
        if let array = objectToSerialize as? NSArray {
            let jsonArray = JsonArray(array: array)
            return jsonArray.toString(self)
        } else if let str = objectToSerialize as? String {
            return "\"\(str)\""
        } else if let number = objectToSerialize as? NSNumber {
            return "\(number)"
        } else if let float = objectToSerialize as? Float {
            return "\(float)"
        } else if let double = objectToSerialize as? Double {
            return "\(double)"
        } else if let int = objectToSerialize as? Int {
            return "\(int)"
        } else if let condition = objectToSerialize as? Bool {
            if (condition == true) {
                return "true"
            } else {
                return "false"
            }
        }

        let jsonObject = JsonObject(object: objectToSerialize as! JsonParseable)
        return jsonObject.toString(self)
    }
    
    /*func fromJson<T: Parseable>(jsonString:String) -> [T] {
        let obj = [T]()
        let data : NSData! = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        let jsonResult: NSDictionary = (NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary)!
        
        ReflectionSetPropertyHelper.setValues(jsonResult as [NSObject : AnyObject], forObject: obj as! AnyObject)
        return obj
    }*/
    
    /*
    let data : NSData! = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
    let jsonResult: NSDictionary = (NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary)!
    */
    
    static func fromJson<T: JsonParseable>(jsonString json:String) -> T? {
        var obj = T.init()
        let className = _stdlib_getDemangledTypeName(obj)
        
        let jsonParser = JsonParser(jsonString: json)
        let jsonResult : JsonConvertible? = jsonParser.parse()
        
        if (!jsonParser.success) {
            return nil
        }
        
        if (jsonResult is JsonConvertibleObject) {
            obj = getComplexObject(jsonResult!, className: className) as! T
        } else {
            obj = jsonResult?.getValue() as! T
        }
        
        return obj
    }
    
    static private func getClass(className : String) -> String {
        let index = className.indexOf("<", after: 0)
        if (index > -1) {
            return className[index + 1...count(className) - 2];
        }
        return className
    }
    
    static private func getComplexObject(jsonResult : JsonConvertible, className : String) -> AnyObject? {
        let detailedClassName = getClass(className)
        var obj: AnyObject! = ReflectionSetPropertyHelper.instantiateClassFromString(detailedClassName);
        NSLog(detailedClassName)
        let hash = jsonResult.getValue() as! NSDictionary;
        var dictionary = NSMutableDictionary();
        var i = 1
        for (key, value) in hash {
            var object : AnyObject?
            if (value is JsonConvertibleObject) {
                let convertible = value as! JsonConvertible
                let reflectObject = reflect(obj)
                let classNameOfValue = _stdlib_getDemangledTypeName(reflectObject[i].1)
                object = getComplexObject(convertible, className: classNameOfValue)
            } else if (value is JsonConvertibleArray) {
                let convertible = value as! JsonConvertibleArray
                let reflectObject = reflect(obj)
                let classNameOfValue = getClass(_stdlib_getDemangledTypeName(reflectObject[i].1))
                
                object = getArray(convertible, className: classNameOfValue)
            } else {
                object = (value as! JsonConvertible).getValue();
            }
            dictionary.setObject(object!, forKey: key as! String);
            i++
        }
        obj = ReflectionSetPropertyHelper.setValues(dictionary as [NSObject : AnyObject], forObject: obj as AnyObject) as! NSObject
        return obj;
    }
    
    static func fromJsonToArray<T>(jsonString json:String) -> T? {
        let jsonParser = JsonParser(jsonString: json)
        let jsonResult : JsonConvertible? = jsonParser.parse()
        
        if (!jsonParser.success) {
            return nil
        }
        var obj : T? = getArray(jsonResult as! JsonConvertibleArray)
        return obj
    }
    
    static private func getArray<T>(jsonArray : JsonConvertibleArray) -> T? {
        let array = jsonArray.getValue() as! NSArray
        let newArray = NSMutableArray()
        for value in array {
            var object : AnyObject?
            if (value is JsonConvertibleObject) {
                let convertibleObj = (value as! JsonConvertibleObject)
                object = getComplexObject(convertibleObj, className: toString(T.self))
            } else if (value is JsonConvertibleArray) {
                object = getArray(value as! JsonConvertibleArray)
            } else {
                object = (value as! JsonConvertible).getValue();
            }
            newArray.addObject(object!)
        }
        
        return newArray as! T;
    }
    
    static private func getArray<T>(jsonArray : JsonConvertibleArray, className : String) -> T? {
        let array = jsonArray.getValue() as! NSArray
        let newArray = NSMutableArray()
        for value in array {
            var object : AnyObject?
            if (value is JsonConvertibleObject) {
                let convertibleObj = (value as! JsonConvertibleObject)
                let obj = convertibleObj.getValue()
                object = getComplexObject(convertibleObj, className: className)
            } else if (value is JsonConvertibleArray) {
                object = getArray(value as! JsonConvertibleArray)
            } else {
                object = (value as! JsonConvertible).getValue();
            }
            newArray.addObject(object!)
        }
        
        return newArray as! T;
    }
}






















