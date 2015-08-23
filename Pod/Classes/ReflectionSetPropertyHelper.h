//
//  ReflectionSetPropertyHelper.h
//  JsonKit
//
//  Created by Alan Quintiliano on 29/05/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReflectionSetPropertyHelper : NSObject

+(id)setValue:(NSObject*)value forProperty:(NSString*)propertyName forObject:(id)object;
+(id)setValues:(NSDictionary *)objectProperties forObject:(id)object;
+(id)instantiateClassFromString:(NSString *)className;

@end
