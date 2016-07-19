//
//  LIUProperty.m
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import "LIUProperty.h"
#import "LIUPropertyType.h"

@implementation LIUProperty

- (instancetype)initWithPorperty:(objc_property_t)property {
    if (self = [super init]) {
        _name = @(property_getName(property));
        _types = [LIUPropertyType typeWithAttributes:@(property_getAttributes(property))];
    }
    return self;
}

+ (instancetype)propertyWithProperty:(objc_property_t)property {
    return [[LIUProperty alloc] initWithPorperty:property];
}
@end

