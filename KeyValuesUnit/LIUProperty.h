//
//  LIUProperty.h
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class LIUPropertyType;
@interface LIUProperty : NSObject
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly) LIUPropertyType *types;

/**
 *  获取到的对象所有属性的封装实例
 *
 *  @param property 属性列表
 *
 *  @return 一个包装属性实例
 */
+ (instancetype)propertyWithProperty:(objc_property_t)property;
@end
