//
//  NSObject+KeyValues.m
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import "NSObject+KeyValues.h"
#import "NSObject+Properties.h"
#import "LIUProperty.h"
#import "LIUPropertyType.h"

@implementation NSObject (KeyValues)

/**
 *  将字典转成模型
 *
 *  @param keyValues 字典
 *
 *  @return 模型
 */
+ (instancetype)objectWithKeyValues:(id)keyValues {
    if (!keyValues) return nil;
    return [[[self alloc] init] setKeyValues:keyValues];
}

+ (NSString *)setPropertyKey:(NSString *)propertyName {
    NSString *key = nil;
    if ([self respondsToSelector:@selector(replaceFromPropertyName)]) {
        key = [self replaceFromPropertyName][propertyName];
    }
    return key?:propertyName;
}

- (instancetype)setKeyValues:(id)keyValues {
    keyValues = [keyValues JsonObj];
    NSArray *propertiesArr = [self.class properties];
    for (LIUProperty *p in propertiesArr) {
        LIUPropertyType *type = p.types;
        Class typeCls = type.typeClass;
        id value = [keyValues valueForKey:[self.class setPropertyKey:p.name]];
        if (!value) continue;
        // 使用递归处理嵌套字典
        if (!type.isFromFoundation && typeCls) {
            value = [typeCls objectWithKeyValues:value];
        } else if ([self respondsToSelector:@selector(objectClassInArray)]) {
            id objCls = [self.class objectClassInArray][p.name];
            if ([objCls isKindOfClass:[NSString class]]) {
                objCls = NSClassFromString(objCls);
            }
            if (objCls) {
                value = [objCls objectArrayWithKeyValues:value];
            }
        } else if (type.isNumberType) { // 进去的都是数字或者BOOL或者Char
            NSString *oldValue = value;
            if ([value isKindOfClass:[NSString class]]) {
                value = [[[NSNumberFormatter alloc] init] numberFromString:value];
                if (type.isBoolType) {
                    NSString *isBool = oldValue.lowercaseString;
                    if ([isBool isEqualToString:@"yes"] || [isBool isEqualToString:@"true"]) {
                        value = @YES;
                    } if ([isBool isEqualToString:@"no"] || [isBool isEqualToString:@"false"]) {
                        value = @NO;
                    }
                }
            }
        } else if (typeCls == [NSString class]) {
            if ([value isKindOfClass:[NSNumber class]]) {
                if (type.isNumberType) {
                    value = [value description];
                } else if ([value isKindOfClass:[NSURL class]]) {
                    value = [value absoluteString];
                }
            }
        }
        [self setValue:value forKey:p.name];
    }
    return self;
}

- (id)JsonObj {
    id foundationObj;
    if ([self isKindOfClass:[NSString class]]) {
        // 如果是字符串
        foundationObj = [NSJSONSerialization JSONObjectWithData:[(NSString *)self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        foundationObj = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    return foundationObj?:self;
}
/**
 *  将一个字典数组转成对象数组
 *
 *  @param keyValuesArray 字典数组
 *
 *  @return 模型数组
 */
+ (NSMutableArray *)objectArrayWithKeyValues:(id)keyValuesArray {
    if ([self isClassFromFoundation:self]) {
        return keyValuesArray;
    }
    keyValuesArray = [keyValuesArray JsonObj];
    NSMutableArray *modelArrM = [NSMutableArray array];
    for (NSDictionary *kvs in keyValuesArray) {
        id model = [self objectWithKeyValues:kvs];
        if (model) {
            [modelArrM addObject:model];
        }
    }
    return modelArrM;
}
@end
