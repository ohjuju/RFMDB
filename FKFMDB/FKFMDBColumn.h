//
//  FKFMDBSetColumn.h
//  FringeKit
//
//  Created by ouok on 15/1/20.
//  Copyright (c) 2015年 ouok. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{   isdatabaseTypeNULL,
    isdatabaseTypeINTEGER,
    isdatabaseTypeREAL,
    isdatabaseTypeTEXT,
    isdatabaseTypeBLOB,
    isdatabaseTypesmallint,
    isdatabaseTypeinterger,
    isdatabaseTypefloat,
    isdatabaseTypedouble,
    isdatabaseTypechar,
    isdatabaseTypevarchar,
    isdatabaseTypegraphic,
    isdatabaseTypevargraphic,
    isdatabaseTypedate,
    isdatabaseTypetime,
    isdatabaseTypetimestamp
}databaseType;

@interface FKFMDBColumn : NSObject

@property (nonatomic, assign) BOOL primary;
@property (nonatomic, assign) BOOL canNULL;
@property (nonatomic, assign) BOOL unique;
@property (nonatomic, assign) NSUInteger length;
@property (nonatomic, assign) databaseType type;
@property (nonatomic, copy) NSString *defaultValue;
@property (nonatomic, copy) NSString *checkCondition;
@property (nonatomic, copy) NSString *keyfromOtherTable;
@property (nonatomic, copy) NSString *theColumn;
@property (nonatomic, copy) NSString *columnName;

- (instancetype)initWithColumn:(NSString *)columnName andType:(databaseType)type;
- (NSString *)buidColumn;

@end
