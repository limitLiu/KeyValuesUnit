//
//  NSObject+Properties.m
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import "NSObject+Properties.h"
#import "LIUProperty.h"

@implementation NSObject (Properties)
static NSSet *foundationClasses_;
static NSMutableDictionary *cacheProperties_;

+ (void)load {
    cacheProperties_ = [NSMutableDictionary dictionary];
}

+ (NSSet *)foundationClasses {
    if (foundationClasses_ == nil) {
        foundationClasses_ = [NSSet setWithObjects:
                              [NSArray class],
                              [NSAttributedString class],
                              [NSData class],
                              [NSDictionary class],
                              [NSNumber class],
                              [NSString class],
                              [NSURL class],
                              [NSValue class], nil];
    }
    return foundationClasses_;
}

+ (BOOL)isClassFromFoundation:(Class)cls {
    if (cls == [NSObject class]) {
        return YES;
    }
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL * _Nonnull stop) {
        if ([cls isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}
/**
 *  获取属性名
 *  使用属性名去字典找匹配值
 *  将字典值转换成数据属性类型
 *  T@"NSString",C,N,V_name
 */
+ (NSArray *)properties {
    NSMutableArray *cacheProperties = cacheProperties_[NSStringFromClass(self)];
    if (!cacheProperties) {
        cacheProperties = [NSMutableArray array];
        unsigned outCount = 0;
        // 属性数组
        objc_property_t *properties = class_copyPropertyList(self, &outCount);
        for (unsigned i = 0; i < outCount; i ++) {
            // 遍历数组
            objc_property_t property = properties[i];
            // 包装属性成一个实例
            LIUProperty *propertyObj = [LIUProperty propertyWithProperty:property];
            //        NSLog(@"%@\t%@", propertyObj.name, propertyObj.types.typeClass);
            [cacheProperties addObject:propertyObj];
        }
        free(properties);
        cacheProperties_[NSStringFromClass(self)] = cacheProperties;
    }
    return cacheProperties;
}
@end
