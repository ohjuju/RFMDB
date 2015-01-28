//
//  FKFMDBResultCondition.m
//  FringeKit
//
//  Created by ouok on 1/23/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import "FKFMDBCondition.h"

@implementation FKFMDBCondition

- (NSString *)buildCondition
{
    return [self WHERE:_whereCondition GROUPBY:_groupbyCondition HAVING:_havingCondition ORDERBY:_orderbyCondition LIMIT:_limit OFFSET:_offset];
}

- (NSString *)WHERE:(NSString *)whereCondition GROUPBY:(NSString *)groupbyCondition HAVING:(NSString *)havingCondition ORDERBY:(NSString *)orderbyCondition LIMIT:(NSInteger)limit OFFSET:(NSInteger)offset
{
    NSString *where = (whereCondition == nil)?@"":[NSString stringWithFormat:@" WHERE %@",whereCondition];
    if (_andCondition != nil) {
        for (int i=0; i<_andCondition.count; i++) {
            where = [where stringByAppendingString:[NSString stringWithFormat:@" AND %@",_andCondition[i]]];
        }
    }
    if (_orCondition != nil)
    {
        for (int i=0; i<_andCondition.count; i++) {
            where = [where stringByAppendingString:[NSString stringWithFormat:@" OR %@",_andCondition[i]]];
        }
    }
    NSString *groupby = (groupbyCondition == nil)?@"":[NSString stringWithFormat:@" GROUP BY %@",groupbyCondition];
    NSString *having = (havingCondition == nil)?@"":[NSString stringWithFormat:@" HAVING %@",havingCondition];
    NSString *orderby = (orderbyCondition == nil)?@"":[NSString stringWithFormat:@" ORDER BY %@",orderbyCondition];
    NSString *limitCondition = @"";
    if (limit>0 && offset>0) {
        limitCondition = [NSString stringWithFormat:@" LIMIT %d,%d",(int)offset,(int)limit];
    }
    return [NSString stringWithFormat:@"%@%@%@%@%@",where,groupby,having,orderby,limitCondition];
}

+ (NSString *)COUNT:(NSString *)columnName
{
    return (columnName != nil)?[NSString stringWithFormat:@"COUNT(%@)",columnName]:@"*";
}

+ (NSString *)SUM:(NSString *)columnName
{
  return (columnName != nil)?[NSString stringWithFormat:@"SUM(%@)",columnName]:@"*";
}

+ (NSString *)AVG:(NSString *)columnName
{
    return (columnName != nil)?[NSString stringWithFormat:@"AVG(%@)",columnName]:@"*";
}

+ (NSString *)MAX:(NSString *)columnName
{
    return (columnName != nil)?[NSString stringWithFormat:@"MAX(%@)",columnName]:@"*";
}

+ (NSString *)MIN:(NSString *)columnName
{
    return (columnName != nil)?[NSString stringWithFormat:@"MIN(%@)",columnName]:@"*";
}

+ (NSString *)COLUMN:(NSString *)columnName LIKE:(NSString *)value
{
    return [NSString stringWithFormat:@"%@ LIKE '%@'",columnName,value];
}
+ (NSString *)COLUMN:(NSString *)columnName GLOB:(NSString *)value
{
    return [NSString stringWithFormat:@"%@ GLOB '%@'",columnName,value];
}


@end
