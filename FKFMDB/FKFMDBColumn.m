//
//  FKFMDBSetColumn.m
//  FringeKit
//
//  Created by ouok on 15/1/20.
//  Copyright (c) 2015年 ouok. All rights reserved.
//

#import "FKFMDBColumn.h"

@implementation FKFMDBColumn

- (instancetype)initWithColumn:(NSString *)columnName andType:(databaseType)type
{
    self = [super init];
    if (self) {
        _columnName = columnName;
        _type = type;
        
        //default _canNULL is YES
        _canNULL = YES;
    }
    return self;
}

- (NSString *)buidColumn
{
    return [self setColumntoString:[self setNewColumnName:_columnName Type:_type isPrinmaryKey:_primary Length:_length canNull:_canNULL defaultValue:_defaultValue isUnique:_unique checkCondition:_checkCondition isFroeignKey:_keyfromOtherTable]];
}

- (NSString *)getTypebyDatabaseType:(databaseType)isType
{
    NSString *type;
    switch (isType) {
        case isdatabaseTypeBLOB:
            type = @"BLOB";
            break;
        case isdatabaseTypechar:
            type = @"char";
            break;
        case isdatabaseTypedate:
            type = @"date";
            break;
        case isdatabaseTypedouble:
            type = @"double";
            break;
        case isdatabaseTypefloat:
            type = @"float";
            break;
        case isdatabaseTypegraphic:
            type = @"graphic";
            break;
        case isdatabaseTypeINTEGER:
            type = @"INTEGER";
            break;
        case isdatabaseTypeinterger:
            type = @"integer";
            break;
        case isdatabaseTypeNULL:
            type = @"NULL";
            break;
        case isdatabaseTypeREAL:
            type = @"REAL";
            break;
        case isdatabaseTypesmallint:
            type = @"smallint";
            break;
        case isdatabaseTypeTEXT:
            type = @"text";
            break;
        case isdatabaseTypetime:
            type = @"time";
            break;
        case isdatabaseTypetimestamp:
            type = @"timestamp";
            break;
        case isdatabaseTypevarchar:
            type = @"varchar";
            break;
        case isdatabaseTypevargraphic:
            type = @"vargraphic";
            break;
        default:
            break;
    }
    return type;
}

- (NSDictionary *)setNewColumnName:(NSString *)columnName Type:(databaseType)type isPrinmaryKey:(BOOL)primaryKey Length:(NSInteger)length canNull:(BOOL)canNull defaultValue:(NSString *)defaultValue isUnique:(BOOL)unique checkCondition:(NSString *)checkCondition isFroeignKey:(NSString *)keyfromOtherTable
{
    return @{@"columnName"    :columnName,
             @"checkCondition":(checkCondition!=nil)?checkCondition:@"",
             @"defaultValue"  :(defaultValue!=nil)?defaultValue:@"",
             @"foreignKey"    :(keyfromOtherTable!=nil)?keyfromOtherTable:@"",
             @"type"          :[self getTypebyDatabaseType:type],
             @"length"        :[NSNumber numberWithInteger:length],
             @"isPrimaryKey"  :[NSNumber numberWithBool:primaryKey],
             @"canNull"       :[NSNumber numberWithBool:canNull],
             @"isUnique"      :[NSNumber numberWithBool:unique]};
}

- (NSString *)setColumntoString:(NSDictionary *)columnDic
{
    //name
    NSString *columnName = [columnDic objectForKey:@"columnName"];
    //type
    NSString *columnType = [NSString stringWithFormat:@" %@",[columnDic objectForKey:@"type"]];
    if ([columnType isEqualToString:@" char"]||[columnType isEqualToString:@" graphic"]) {
        columnType = [NSString stringWithFormat:@"%@(%d)",columnType,(int)[[columnDic objectForKey:@"length"] integerValue]];
    }
    //primary
    NSString *columnPrimary = [[columnDic objectForKey:@"isPrimaryKey"] boolValue]?@" PRIMARY KEY":@"";
    if (([columnType isEqualToString:@" integer"]||[columnType isEqualToString:@" INTEGER"])&&![columnPrimary isEqualToString:@""]) {
        columnPrimary = [columnPrimary stringByAppendingString:@" AUTOINCREMENT"];
    }
    //foreign
    NSString *columnForeign = [[columnDic objectForKey:@"foreignKey"] isEqualToString:@""]?@"":[NSString stringWithFormat:@" FOREIGN KEY(%@) REFERENCES %@",columnName,[columnDic objectForKey:@"foreignKey"]];
    //default
    NSString *columnDefault = [[columnDic objectForKey:@"defaultValue"] isEqualToString:@""]?@"":[NSString stringWithFormat:@" DEFAULT'%@'",[columnDic objectForKey:@"defaultValue"]];
    //null
    NSString *columnNull = [[columnDic objectForKey:@"canNull"] boolValue]?@"":@" NOT NULL";
    //unique
    NSString *columnUnique = [[columnDic objectForKey:@"isUnique"] boolValue]?@" UNIQUE":@"";
    //check
    NSString *columnCheck = [[columnDic objectForKey:@"checkCondition"] isEqualToString:@""]?@"":[NSString stringWithFormat:@" CHECK(%@)",[columnDic objectForKey:@"checkCondition"]];
    
    //combine all values
    NSString *columnString = [NSString stringWithFormat: @"%@%@%@%@%@%@%@%@",columnName,columnType,columnPrimary,columnNull,columnDefault,columnUnique,columnCheck,columnForeign];
    return columnString;
}

@end
