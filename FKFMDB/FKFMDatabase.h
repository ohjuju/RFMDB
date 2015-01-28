//
//  FMDBData.h
//  FringeKit
//
//  Created by ouok on 1/5/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDB.h"

#import "FKFMDBColumn.h"
#import "FKFMDBCondition.h"

typedef enum
{   count,
    sum,
    avg,
    max,
    min
}selectQuery;

@interface FKFMDatabase : NSObject

@property (nonatomic, strong) FMDatabase *database;

- (instancetype)init;
- (instancetype)initWithDatabaseName:(NSString *)databaseName;
- (instancetype)initWithDatabasePath:(NSString *)databasePath;

- (void)open;
- (void)close;
- (void)executeUpdate:(NSString *)sql;
- (FMResultSet *)executeQuery:(NSString *)sql;
- (BOOL)beginTransition;
- (BOOL)commit;

//distinct
@property (nonatomic, assign) BOOL dictinct;

- (FMResultSet *)queryDataWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName;

- (void)createTable:(NSString *)tableName columnAndTypeStringArray:(NSArray *)columnAndTypeStringArray;

- (void)insertDataWithColum:(NSDictionary *)dic intoTable:(NSString *)tableName;
- (void)insertDataWithColumDicArray:(NSArray *)columnAndDataDicArray intoTable:(NSString *)tableName;

- (void)deleteDataWithCondition:(NSString *)condition fromTable:(NSString *)tableName;

- (void)updateDataWithColumns:(NSDictionary *)dic condition:(NSString *)condition toTable:(NSString *)tableName;
- (void)updateDataWithColumDicArray:(NSArray *)columnAndDataDicArray condition:(NSString *)condition toTable:(NSString *)tableName;

- (NSString *)querytheDataWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName;
- (NSArray *)querytheDatatoArrayWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName;

//selectQuery
- (NSNumber *)queryDataWithOperation:(selectQuery)operation ofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition;

//alert columns
- (void)addColumntoTable:(NSString *)tableName columnNameAndTypeArray:(NSArray *)columnNameAndTypeArray;

@end
