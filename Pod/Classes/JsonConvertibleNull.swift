//
//  JsonConvertibleNull.swift
//  QsonTest
//
//  Created by Alan Quintiliano on 16/08/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

import Foundation

class JsonConvertibleNull : JsonConvertible
{
    func getValue() -> AnyObject? {
        return nil;
    }
}