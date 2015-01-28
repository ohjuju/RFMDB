//
//  FKFMDBResultCondition.h
//  FringeKit
//
//  Created by ouok on 1/23/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import <Foundation/Foundation.h>


//typedef enum
//{   count,
//    sum,
//    avg,
//    max,
//    min
//}selectQuery;

@interface FKFMDBCondition : NSObject

/*like glob*/
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
+ (NSString *)COLUMN:(NSString *)columnName LIKE:(NSString *)value;
+ (NSString *)COLUMN:(NSString *)columnName GLOB:(NSString *)value;

@end
