//
//  LIUPropertyType.m
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import "LIUPropertyType.h"
#import "LIUConst.h"
#import "NSObject+Properties.h"

@implementation LIUPropertyType

static NSMutableDictionary *cacheCodes_;
+ (void)load {
    cacheCodes_ = [NSMutableDictionary dictionary];
}

- (instancetype)initWithAttributes:(NSString *)attributes {
    
    NSUInteger length = [attributes rangeOfString:@","].location - 1;
    NSString *typeName = [attributes substringWithRange:NSMakeRange(1, length)];
    if (cacheCodes_[typeName] == nil) {
        self = [super init];
        [self getTypeCode:typeName];
        cacheCodes_[typeName] = self;
    }
    return self;
}

+ (instancetype)typeWithAttributes:(NSString *)attributes {
    return [[LIUPropertyType alloc] initWithAttributes:attributes];
}

- (void)getTypeCode:(NSString *)code {
    if ([code isEqualToString:LIUPropertyTypeId]) {
        _idType = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) { // 截取类型名
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _numberType = (_typeClass == [NSNumber class] || [_typeClass isSubclassOfClass:[NSNumber class]]);
        
        _fromFoundation = [NSObject isClassFromFoundation:_typeClass];
    }
    // 判断是否是number类型
    NSString *lowerStr = code.lowercaseString;
    NSArray *typeArr = @[LIUPropertyTypeInt,
                         LIUPropertyTypeShort,
                         LIUPropertyTypeFloat,
                         LIUPropertyTypeDouble,
                         LIUPropertyTypeLong,
                         LIUPropertyTypeLongLong,
                         LIUPropertyTypeChar,
                         LIUPropertyTypeBOOL1,
                         LIUPropertyTypeBOOL2];
    if ([typeArr containsObject:lowerStr]) {
        _numberType = YES;
        if ([lowerStr isEqualToString:LIUPropertyTypeBOOL1] || [lowerStr isEqualToString:LIUPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}
@end