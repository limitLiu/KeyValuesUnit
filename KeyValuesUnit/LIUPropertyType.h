//
//  LIUPropertyType.h
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  封装屬性类型
 */
@interface LIUPropertyType : NSObject
/** 类型码用于判断 */
@property(nonatomic, copy) NSString *code;
/** 判断是否是id类型 */
@property(nonatomic, readonly, getter=isIdType) BOOL idType;
/** 判断是否是基本数据类型 */
@property(nonatomic, readonly, getter=isNumberType) BOOL numberType;
/** 判断是否是BOOL类型 */
@property(nonatomic, readonly, getter=isBoolType) BOOL boolType;
/** 判断是否是Foundation类型 */
@property(nonatomic, readonly, getter=isFromFoundation) BOOL fromFoundation;
/** 判断是否是对象类型 */
@property(nonatomic, readonly) Class typeClass;


+ (instancetype)typeWithAttributes:(NSString *)attributes;
@end