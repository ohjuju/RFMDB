//
//  FKFMDBResultCondition.h
//  FringeKit
//
//  Created by ouok on 1/23/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKFMDBCondition : NSObject

/*
 [self WHERE:_whereCondition GROUPBY:_groupbyCondition HAVING:_havingCondition ORDERBY:_orderbyCondition LIMIT:_limit OFFSET:_offset]
 */
@property (nonatomic, copy) NSString *whereCondition;
@property (nonatomic, copy) NSArray *andCondition;
@property (nonatomic, copy) NSArray *orCondition;
@property (nonatomic, copy) NSString *orderbyCondition;
@property (nonatomic, copy) NSString *groupbyCondition;
@property (nonatomic, copy) NSString *havingCondition;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;

- (NSString *)buildCondition;

+ (NSString *)COUNT:(NSString *)columnName;
+ (NSString *)SUM:(NSString *)columnName;
+ (NSString *)AVG:(NSString *)columnName;
+ (NSString *)MAX:(NSString *)columnName;
+ (NSString *)MIN:(NSString *)columnName;
/*like*/
+ (NSString *)COLUMN:(NSString *)columnName LIKE:(NSString *)value;
/*glob*/
+ (NSString *)COLUMN:(NSString *)columnName GLOB:(NSString *)value;

@end
