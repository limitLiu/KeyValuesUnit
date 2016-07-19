//
//  NSObject+KeyValues.h
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LIUKeyValues <NSObject>
@optional

/**
 *  用于声明类中数组转成对应的哪个模型
 */
+ (NSDictionary *)objectClassInArray;
/** 
 *  返回一个字典<br />
 *  因为 id 和 description 在objc中有特殊含义<br />
 *  前面是当前类某个属性名, 后面接获取的数据的键<br />
 *  <pre>
 *  eg:<br />
 *      假设接到的数据类型是{"id": "1"}<br />
 *      interface:<br />
 *          \@property(nonatomic, copy) NSString *idStr;<br />
 *      implement:<br />
 *          + (NSDictionary *)replaceFromPropertyName {<br />
 *              return \@{\@"idStr": \@"id"};<br />
 *          }
 *  </pre>
 */
+ (NSDictionary *)replaceFromPropertyName;
@end
@interface NSObject (KeyValues) <LIUKeyValues>
+ (instancetype)objectWithKeyValues:(id)keyValues;
+ (NSMutableArray *)objectArrayWithKeyValues:(id)keyValuesArray;
@end