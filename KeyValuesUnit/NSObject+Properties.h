//
//  NSObject+Properties.h
//  KeyValuesUnit
//
//  Created by 劉裕 on 11/4/2016.
//  Copyright © 2016年 劉裕. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Properties)
+ (NSArray *)properties;
+ (BOOL)isClassFromFoundation:(Class)cls;
@end
