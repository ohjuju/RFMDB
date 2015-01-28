//
//  FMDBData.m
//  FringeKit
//
//  Created by ouok on 1/5/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import "FKFMDatabase.h"

@implementation FKFMDatabase

@synthesize database = _database;

- (instancetype)init
{
    return [self initWithDatabaseName:@"database"];
}

- (instancetype)initWithDatabaseName:(NSString *)databaseName
{
    self = [super init];
    if (self) {
        _database = [[FMDatabase alloc] initWithPath:[self getPath:databaseName]];
        if (![_database open]) {
            NSLog(@"open database failed.");
        }else {
            [_database close];
        }
    }
    return self;
}

- (instancetype)initWithDatabasePath:(NSString *)databasePath
{
    self = [super init];
    if (self) {
        _database = [[FMDatabase alloc] initWithPath:databasePath];
        if (![_database open]) {
            NSLog(@"open database failed.");
        }else {
            [_database close];
        }
    }
    return self;
}

#pragma mark - sqlFunction

- (NSString *)getPath:(NSString *)databaseName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"the path of %@ is %@",databaseName,[[paths objectAtIndex:0] stringByAppendingPathComponent:databaseName]);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:databaseName];
}

#pragma mark - baseFunction
-(void)open
{
    BOOL rec=[_database open];
    if (!rec) {
        NSLog(@"open database failed");
    }
}
-(void)close
{
    BOOL rec=[_database close];
    if (!rec) {
        NSLog(@"close database failed");
    }
}

-(void)executeUpdate:(NSString *)sql
{
    [_database executeUpdate:sql];
}

-(FMResultSet *)executeQuery:(NSString *)sql
{
    return [_database executeQuery:sql];
}

-(BOOL)beginTransition
{
    return [_database beginTransaction];
}

- (BOOL)commit
{
    return [_database commit];
}

- (void)insertDataWithColum:(NSDictionary *)dic intoTable:(NSString *)tableName
{
    NSString * columnNames = [dic.allKeys componentsJoinedByString:@", "];
    
    NSMutableArray * questionMarkArray = [NSMutableArray array];
    for (id key in dic)
    {
        [questionMarkArray addObject:@"?"];
    }
    NSString * valueStr = [questionMarkArray componentsJoinedByString:@", "];
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@);", tableName, columnNames, valueStr];
    [_database beginTransaction];
    [_database executeUpdate:sql withArgumentsInArray:dic.allValues];
    [_database commit];
    BOOL rec = [_database executeUpdate:sql withArgumentsInArray:dic.allValues];
    if (!rec) {
        perror([sql UTF8String]);
//        [_database rollback];
    }
}

- (void)deleteDataWithCondition:(NSString *)condition fromTable:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (condition!=nil) {
        sql=[sql stringByAppendingFormat:@" WHERE %@",condition];
    }
    sql = [sql stringByAppendingString:@";"];
    [_database beginTransaction];
    BOOL rec = [_database executeUpdate:sql];
    [_database commit];
    if (!rec) {
        perror([sql UTF8String]);
        //        [_database rollback];
    }
}

- (void)updateDataWithColumns:(NSDictionary *)dic condition:(NSString *)condition toTable:(NSString *)tableName
{
    NSString * sql = [NSString stringWithFormat:@"UPDATE %@ SET ", tableName];
    NSMutableArray * questionMarkArray = [NSMutableArray array];
    for (NSString *key in dic) {
        [questionMarkArray addObject:[NSString stringWithFormat:@"%@=?",key]];
    }
    NSString *str=[questionMarkArray componentsJoinedByString:@","];
    sql=[sql stringByAppendingFormat:@"%@ WHERE %@",str,condition];
    sql = [sql stringByAppendingString:@";"];
    [_database beginTransaction];
    BOOL rec = [_database executeUpdate:sql withArgumentsInArray:dic.allValues];
    [_database commit];
    NSLog(@"update sql=%@",sql);
    if (!rec) {
        perror([sql UTF8String]);
//        [_database rollback];
    }
}

- (FMResultSet *)queryDataWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName
{
    NSString * colNames = nil;
    if (names == nil) {
        colNames = @"*";
    } else {
        colNames = [names componentsJoinedByString:@", "];
    }
    NSString *sql = @"SELECT";
    if (_dictinct == YES) {
        sql = [sql stringByAppendingString:@" DISTINCT"];
    }
    sql = [sql stringByAppendingFormat:@" %@ FROM %@",colNames,tableName];
    if (condition!=nil) {
        sql=[sql stringByAppendingFormat:@"%@",condition];
    }
    sql = [sql stringByAppendingString:@";"];
    NSLog(@"querysql=%@",sql);
    FMResultSet * rs = [_database executeQuery:sql];
    while (rs.next) {
        return rs;
    }
    return nil;
}

#pragma mark - second stage
- (void)createTable:(NSString *)tableName columnAndTypeStringArray:(NSArray *)columnAndTypeStringArray
{
    NSString *createCondition;
    if (columnAndTypeStringArray.count >1) {
        createCondition = [columnAndTypeStringArray componentsJoinedByString:@", "];
    }else {
        createCondition = [columnAndTypeStringArray objectAtIndex:0];
    }
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);",tableName,createCondition];
    NSLog(@"createSql= [%@]",sql);
    [_database beginTransaction];
    BOOL rec = [_database executeUpdate:sql];
    [_database commit];
    if (!rec) {
        perror([sql UTF8String]);
    }
}

- (void)insertDataWithColumDicArray:(NSArray *)columnAndDataDicArray intoTable:(NSString *)tableName
{
    [_database beginTransaction];
    for (int i=0; i<columnAndDataDicArray.count; i++) {
        NSMutableArray * questionMarkArray = [NSMutableArray array];
        NSString * columnNames = [((NSDictionary *)columnAndDataDicArray[i]).allKeys componentsJoinedByString:@", "];
        for (id key in (NSDictionary *)columnAndDataDicArray[i])
        {
            [questionMarkArray addObject:@"?"];
        }
        NSString * valueStr = [questionMarkArray componentsJoinedByString:@", "];
        NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@);", tableName, columnNames, valueStr];
        NSLog(@"insertSql=[%@]",sql);
        
        [_database executeUpdate:sql withArgumentsInArray:((NSDictionary *)columnAndDataDicArray[i]).allValues];
        
        BOOL rec = [_database executeUpdate:sql withArgumentsInArray:((NSDictionary *)columnAndDataDicArray[i]).allValues];
        if (!rec) {
            perror([sql UTF8String]);
//            [_database rollback];
        }
    }
    [_database commit];
    
}
- (void)updateDataWithColumDicArray:(NSArray *)columnAndDataDicArray condition:(NSString *)condition toTable:(NSString *)tableName
{
    [_database beginTransaction];
    for (int i=0; i<columnAndDataDicArray.count; i++) {
        NSMutableArray * questionMarkArray = [NSMutableArray array];
        NSString * sql = [NSString stringWithFormat:@"UPDATE %@ SET ", tableName];
        for (NSString *key in (NSDictionary *)columnAndDataDicArray[i]) {
            [questionMarkArray addObject:[NSString stringWithFormat:@"%@=?",key]];
        }
        NSString *str=[questionMarkArray componentsJoinedByString:@","];
        sql=[sql stringByAppendingFormat:@"%@ where %@",str,condition];
        sql = [sql stringByAppendingString:@";"];
        
        [_database executeUpdate:sql withArgumentsInArray:((NSDictionary *)columnAndDataDicArray[i]).allValues];
        
        BOOL rec = [_database executeUpdate:sql withArgumentsInArray:((NSDictionary *)columnAndDataDicArray[i]).allValues];
        NSLog(@"update sql=[%@]",sql);
        if (!rec) {
            perror([sql UTF8String]);
//            [_database rollback];
        }
    }
    [_database commit];
}

- (NSArray *)querytheDatatoArrayWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName
{
    FMResultSet * rs = [self queryDataWithColumns:names condition:condition fromTable:tableName];
    NSMutableArray *rsArray = [NSMutableArray new];
    if (names == nil) {
        NSMutableDictionary *rsDic = [NSMutableDictionary new];
        while (rs.next) {
            NSMutableArray *objectArray = [NSMutableArray new];
            for (int i=0; i<[rs columnCount]; i++) {
                NSString *columnName = [[rs columnNameToIndexMap].allKeys objectAtIndex:i];
                [objectArray addObject:[rs objectForColumnName:columnName]];
            }

            rsDic = [[NSMutableDictionary alloc] initWithObjects:objectArray forKeys:[rs columnNameToIndexMap].allKeys];
            [rsArray addObject:rsDic];
        }
    }else {
        NSMutableDictionary *rsDic = [NSMutableDictionary new];
        while (rs.next) {
            NSMutableArray *objectArray = [NSMutableArray new];
            for (int i=0; i<names.count; i++) {
                [objectArray addObject:[rs objectForColumnIndex:i]];
            }
            rsDic = [[NSMutableDictionary alloc] initWithObjects:objectArray forKeys:names];
            [rsArray addObject:rsDic];
        }
    }
    return rsArray;
}

- (NSString *)querytheDataWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName
{
    return [NSString stringWithFormat:@"%@",[self querytheDatatoArrayWithColumns:names condition:condition fromTable:tableName]];
}

- (void)addColumntoTable:(NSString *)tableName columnNameAndTypeArray:(NSArray *)columnNameAndTypeArray
{
    [_database beginTransaction];
    for (int i=0; i<columnNameAndTypeArray.count; i++) {
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@",tableName,columnNameAndTypeArray[i]];
        NSLog(@"altersql=[%@]",sql);
        BOOL rec = [_database executeUpdate:sql];
        if (!rec) {
            perror([sql UTF8String]);
        }
    }
    [_database commit];
}

#pragma mark - count,sum,avg,min,max

- (NSNumber *)queryDataWithOperation:(selectQuery)operation ofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition
{
    switch (operation) {
        case count:
            return [self theNumofColumn:columnName fromTable:tableName withCondition:condition];
            break;
        case sum:
            return [self theSumofColumn:columnName fromTable:tableName withCondition:condition];
            break;
        case avg:
            return [self theAvgofColumn:columnName fromTable:tableName withCondition:condition];
            break;
        case max:
            return [self theMaxofColumn:columnName fromTable:tableName withCondition:condition];
            break;
        case min:
            return [self theMinofColumn:columnName fromTable:tableName withCondition:condition];
            break;
        default:
            break;
    }
    return nil;
}

- (NSNumber *)theNumofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition
{
    NSString *column;
    if ([columnName isEqualToString:@""]||columnName == nil) {
        column = @"*";
    }else{
        column = columnName;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(%@) AS 'COUNT' FROM %@",column,tableName];
    if (condition!=nil) {
        sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,condition];
    }
    sql = [sql stringByAppendingString:@";"];

    NSLog(@"countsql=%@",sql);
    FMResultSet * rs = [_database executeQuery:sql];
    while (rs.next) {
        return [NSNumber numberWithInt:[rs intForColumn:@"COUNT"]];
    }
    return 0;
}

- (NSNumber *)theSumofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition
{
    NSString *column;
    if ([columnName isEqualToString:@""]||columnName == nil) {
        NSLog(@"columnName can not null");
    }else{
        column = columnName;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT SUM(%@) AS 'SUM' FROM %@",column,tableName];
    if (condition!=nil) {
        sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,condition];
    }
    sql = [sql stringByAppendingString:@";"];

    NSLog(@"sumsql=%@",sql);
    FMResultSet * rs = [_database executeQuery:sql];
    while (rs.next) {
        return [rs objectForColumnName:@"SUM"];
    }
    return 0;
}
- (NSNumber *)theMaxofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition
{
    NSString *column;
    if ([columnName isEqualToString:@""]||columnName == nil) {
        NSLog(@"columnName can not null");
    }else{
        column = columnName;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT MAX(%@) AS 'MAX' FROM %@",column,tableName];
    if (condition!=nil) {
        sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,condition];
    }
    sql = [sql stringByAppendingString:@";"];

    NSLog(@"maxsql=%@",sql);
    FMResultSet * rs = [_database executeQuery:sql];
    while (rs.next) {
        return [rs objectForColumnName:@"MAX"];
    }
    return 0;
}
- (NSNumber *)theMinofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition
{
    NSString *column;
    if ([columnName isEqualToString:@""]||columnName == nil) {
        NSLog(@"columnName can not null");
    }else{
        column = columnName;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT MIN(%@) AS 'MIN' FROM %@",column,tableName];
    if (condition!=nil) {
        sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,condition];
    }
    sql = [sql stringByAppendingString:@";"];

    NSLog(@"minsql=%@",sql);
    FMResultSet * rs = [_database executeQuery:sql];
    while (rs.next) {
        return [rs objectForColumnName:@"MIN"];
    }
    return 0;
}
- (NSNumber *)theAvgofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition
{
    NSString *column;
    if ([columnName isEqualToString:@""]||columnName == nil) {
        NSLog(@"columnName can not null");
    }else{
        column = columnName;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT AVG(%@) AS AVG FROM %@",column,tableName];
    if (condition!=nil) {
        sql = [NSString stringWithFormat:@"%@ WHERE %@",sql,condition];
    }
    sql = [sql stringByAppendingString:@";"];
    NSLog(@"avgsql=%@",sql);
    FMResultSet * rs = [_database executeQuery:sql];
    while (rs.next) {
        return [rs objectForColumnName:@"AVG"];
    }
    return 0;
}
@end
