//
//  ReflectionSetPropertyHelper.m
//  JsonKit
//
//  Created by Alan Quintiliano on 29/05/15.
//  Copyright (c) 2015 Alan Quintiliano. All rights reserved.
//

#import "ReflectionSetPropertyHelper.h"

@implementation ReflectionSetPropertyHelper

+(id)setValue:(NSObject*)value forProperty:(NSString*)propertyName forObject:(id)object
{
    [object setValue:value forKey:propertyName];
    return object;
}

+(id)setValues:(NSDictionary *)objectProperties forObject:(id)object
{
    for (NSString * propertyName in objectProperties.allKeys) {
        id propertyValue = [objectProperties valueForKey:propertyName];
        [object setValue:propertyValue forKey:propertyName];
    }
    return object;
}

+(id)instantiateClassFromString:(NSString *)className
{
    return [[NSClassFromString(className) alloc] init];
}

@end
