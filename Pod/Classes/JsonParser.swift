  //
//  JsonParser.swift
//  ZapCar
//
//  Created by Alan Quintiliano on 01/06/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonParser {
    
    private let JSON_NUMBER = "Number"

    private var charIndex = 0
    private let jsonString : String
    var success = true;
    
    init(jsonString:String) {
        self.jsonString = jsonString
    }
    
    func parse() -> JsonConvertible? {
        return parseValue()
    }
    
    private func parseValue() -> JsonConvertible? {
        let token = lookAhead()
        
        if token == "\"" {
            return parseString()
        } else if token == JSON_NUMBER {
            return parseNumber()
        } else if token == "{" {
            return parseObject() //Detect what class
        } else if token == "[" {
            return parseArray() //Detect what class
        } else if token == "false" {
            //nextToken()
            let json = JsonConvertibleSimpleObject(value: false)
            return json
        } else if token == "true" {
            let json = JsonConvertibleSimpleObject(value: true)
            return json
        } else if token == "null" {
            let json = JsonConvertibleNull()
            return json
        }
        success = false
        return nil
    }
    
    private func parseObject() -> JsonConvertibleObject? {
        //charIndex++
        
        var hash = NSMutableDictionary();//[String: JsonConvertible?]();
        var token : String?
        var done = false;
        var index = 0
        
        nextToken()
        
        while !done {
            token = lookAhead()
            if token == nil {
                success = false
                return nil
            } else if token == "," {
                nextToken()
            } else if token == "}" {
                nextToken()
                
//                let object =
//                let obj = ReflectionSetPropertyHelper.setValues(hash, forObject: object)
                let json = JsonConvertibleObject(value: hash)
                return json;
            } else {
                let name = parseString()?.getValue() as! String
                if !success {
                    success = false
                    return nil
                }
                
                token = nextToken()
                if token != ":" {
                    success = false
                    return nil
                }
                
                //let reflectObject = reflect(obj)
                //let typeClass = reflectObject[index].1.value.dynamicType
                
                let object = parseValue()
                if !success {
                    success = false
                    return nil
                }
                
                hash.setObject(object as! AnyObject, forKey: name);
                index++
            }
        }
    }
    
    private func parseArray() -> JsonConvertibleArray? {
        let json = JsonConvertibleArray()
        nextToken()
        
        var done = false
        while !done {
            var token = lookAhead()
            if token == nil {
                success = false
                return nil
            } else if token == "," {
                nextToken()
            } else if token == "]" {
                nextToken()
                break
            } else {
                let object = parseValue()
                if !success {
                    return nil
                }
                
                json.append(object)
            }
        }

        return json
    }

    private func parseString() -> JsonConvertibleSimpleObject? {
        var str = ""
        var char : Character
        eatWhitespaces()
        char = jsonString[charIndex++]
        
        var done = false
        while (!done) {
            if charIndex == count(jsonString) {
                break
            }
            char = jsonString[charIndex++]
            if char == "\"" {
                done = true
                break
            }
            if char == "\\" {
                if charIndex == count(jsonString) {
                    break
                }
                char = jsonString[charIndex++]
                if char == "\"" || char == "\\" || char == "/" {
                    str.append(char)
                } else if char == "b" {
                    str += "\\b"
                } else if char == "f" {
                    str += "\\f"
                } else if char == "n" {
                    str += "\\n"
                } else if char == "r" {
                    str += "\\r"
                } else if char == "t" {
                    str += "\\t"
                } else if char == "u" {
                    let remainingLength = count(jsonString) - charIndex
                    if remainingLength >= 4 {
                        let codePoint : UInt32
                        //codePoint = jsonString[charIndex...charIndex + 4] //HEX maybe?
                        //success if can parse it
                        //How to do it?
                        //str += str.append(Char.ConvertFromUtf32((int)codePoint));
                        charIndex += 4
                    } else {
                        break
                    }
                }
            } else {
                str.append(char)
            }
        }
        
        if (!done) {
            success = false
            return nil
        }
        
        let json = JsonConvertibleSimpleObject(value: str)
        return json
    }
    
    private func parseNumber() -> JsonConvertibleSimpleObject {
        eatWhitespaces()
        
        let lastIndex = getLastIndexOfNumber()
        let charLength = (lastIndex - charIndex)
        let str = jsonString[charIndex...charIndex + charLength] as NSString
        let double = str.doubleValue
        
        charIndex = charIndex + charLength + 1
        let json = JsonConvertibleSimpleObject(value: double)
        return json
    }


    private func nextToken() -> String? {
        eatWhitespaces()
        
        if charIndex == count(jsonString) {
            return nil
        }
        
        let token = jsonString[charIndex...charIndex]
        
        charIndex++
        
        if token == "0" || token == "1" || token == "2" || token == "3" || token == "4" || token == "5" ||
            token == "6" || token == "7" || token == "8" || token == "9" || token == "-" {
            return JSON_NUMBER
        } else if token == "{" || token == "}" || token == "[" || token == "]" || token == ":" || token == "," || token == "\"" {
            return token
        }

        charIndex--;

        let remainingLength = count(jsonString) - charIndex
        
        if remainingLength >= 5 {
            if jsonString[charIndex] == "f" && jsonString[charIndex + 1] == "a" && jsonString[charIndex + 2] == "l" && jsonString[charIndex + 3] == "s" && jsonString[charIndex + 4] == "e" {
                charIndex += 6
                return "false"
            }
        }
        
        if remainingLength >= 4 {
            if jsonString[charIndex] == "t" && jsonString[charIndex + 1] == "r" && jsonString[charIndex + 2] == "u" && jsonString[charIndex + 3] == "e" {
                charIndex += 5
                return "true"
            } else if jsonString[charIndex] == "n" && jsonString[charIndex + 1] == "u" && jsonString[charIndex + 2] == "l" && jsonString[charIndex + 3] == "l" {
                charIndex += 5
                return "null"
            }
        }
        
        return nil
    }

    private func eatWhitespaces() {
        for (; charIndex < count(jsonString); charIndex++) {
            if jsonString[charIndex] != " " || jsonString[charIndex] != "\t" || jsonString[charIndex] != "\n" || jsonString[charIndex] != "\r" {
                break;
            }
        }
    }

    private func getLastIndexOfNumber() -> Int {
        var lastIndex : Int
        for lastIndex = charIndex; lastIndex <= count(jsonString); lastIndex++ {
            if jsonString[lastIndex] != "0" && jsonString[lastIndex] != "1" && jsonString[lastIndex] != "2" && jsonString[lastIndex] != "3" && jsonString[lastIndex] != "4" && jsonString[lastIndex] != "5" && jsonString[lastIndex] != "6" && jsonString[lastIndex] != "7" && jsonString[lastIndex] != "8" && jsonString[lastIndex] != "9" && jsonString[lastIndex] != "." && jsonString[lastIndex] != "E" && jsonString[lastIndex] != "+" && jsonString[lastIndex] != "e" && jsonString[lastIndex] != "-" {
                break
            }
        }
        return lastIndex - 1
    }
    
    private func lookAhead() -> String? {
        let token = nextToken()
        charIndex--
        return token
    }
}