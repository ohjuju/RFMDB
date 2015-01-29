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

/*
 @return `YES` upon this column is primaryKey, `NO` upon no.
        Default is NO;
 */
@property (nonatomic, assign) BOOL primary;
/*
 @return `YES` upon this column can NULL; `NO` upon NOT NULL. 
        Default is YES;
 */
@property (nonatomic, assign) BOOL canNULL;
/*
 @return `YES` upon this column set unique; `NO` upon no. 
        Default is NO
 */
@property (nonatomic, assign) BOOL unique;
/*
 @return a type length if your type need limit.
 */
@property (nonatomic, assign) NSUInteger length;
/*
 this is a enum to let you choose the column type
 */
@property (nonatomic, assign) databaseType type;
/*
 type the 'defaultVaule' you want to set in column.
 */
@property (nonatomic, copy) NSString *defaultValue;
/*
 type the 'checkCondition' you want to set in column.
 */
@property (nonatomic, copy) NSString *checkCondition;
/*
 type the 'foreignKeyCondition' you want to set in column,like "otherTableName(column)",you can use the [+ (NSString *)REFERENCESKEY:(NSString *)column FROMTABLE:(NSString *)tableName] to set your foreignKeyCondition.
 */
@property (nonatomic, copy) NSString *foreignKeyCondition;
@property (nonatomic, copy) NSString *theColumn;
@property (nonatomic, copy) NSString *columnName;

- (instancetype)initWithColumn:(NSString *)columnName andType:(databaseType)type;
- (NSString *)buidColumn;

//foreignKey
+ (NSString *)REFERENCESKEY:(NSString *)column FROMTABLE:(NSString *)tableName;

@end
