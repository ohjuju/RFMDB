//
//  FMDBData.h
//  FringeKit
//
//  Created by ouok on 1/5/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FMDB/FMDB.h>

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

- (BOOL)open;
- (BOOL)close;
- (BOOL)executeUpdate:(NSString *)sql;
- (FMResultSet *)executeQuery:(NSString *)sql;
- (BOOL)beginTransition;
- (BOOL)commit;
- (BOOL)rollBack;

/* create Table
 @param 'tableName' is the table you want to create.
        'columnAndTypeStringArray' is the format by @[
                                           @{@"columnName"    :columnName,
                                             @"checkCondition":checkCondition,
                                             @"defaultValue"  :defaultValue,
                                             @"foreignKey"    :keyfromOtherTable,
                                             @"type"          :type,
                                             @"length"        :length,
                                             @"isPrimaryKey"  :primaryKey,
                                             @"canNull"       :canNull,
                                             @"isUnique"      :unique
                                            },
                                            ...
                                        ]
        You can use the "FKFMDBColumn" to generate this array.
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)createTable:(NSString *)tableName columnAndTypeStringArray:(NSArray *)columnAndTypeStringArray;

/** insert
 @param 'tableName' is the table you want to create.
 'columnAndTypeStringArray' is the format by@[
                                            @{  @"columnName1":value,
                                                @"columnName2":value,
                                                @"columnName3":value,
                                                @"columnName4":value,
                                            },
                                            ...
                                            ]
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)insertDataWithColumDicArray:(NSArray *)columnAndDataDicArray intoTable:(NSString *)tableName;

/* delete
 @param 'tableName' is the table you want to create.
        You can use the "FKFMDBCondition" to generate the 'condition' or you should type the condition in String.
        If the condition is nil,return "*"
 
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)deleteDataWithCondition:(NSString *)condition fromTable:(NSString *)tableName;

/** update
 @param 'tableName' is the table you want to create.
        'columnAndTypeStringArray' is the format by@[
                                                        @{  @"columnName1":value,
                                                            @"columnName2":value,
                                                            @"columnName3":value,
                                                            @"columnName4":value,
                                                        },
                                                        ...
                                                    ]
        You can use the "FKFMDBCondition" to generate the 'condition' or you should type the condition in String.
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)updateDataWithColumDicArray:(NSArray *)columnAndDataDicArray condition:(NSString *)condition toTable:(NSString *)tableName;

/*dictinct is used to remove duplicate query results*/
@property (nonatomic, assign) BOOL dictinct;

/** query
 @param 'tableName' is the table you want to create.
        'names' is the format by @[@"columnName1",@"columnName2",...].
                If 'names' is nil,return "*"
        You can use the "FKFMDBCondition" to generate the 'condition' or you should type the condition in String.
 @return a JSONString or NSArray included Dic.
 */
- (NSString *)querytheDataWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName;
- (NSArray *)querytheDatatoArrayWithColumns:(NSArray *)names condition:(NSString *)condition fromTable:(NSString *)tableName;

/** alert column
 
 @param 'tableName' is the table you want to create.
        'columnAndTypeArray' is the format by @[
                                                @{@"columnName"    :columnName,
                                                @"checkCondition":checkCondition,
                                                @"defaultValue"  :defaultValue,
                                                @"foreignKey"    :keyfromOtherTable,
                                                @"type"          :type,
                                                @"length"        :length,
                                                @"isPrimaryKey"  :primaryKey,
                                                @"canNull"       :canNull,
                                                @"isUnique"      :unique
                                                },
                                                ...
                                                ]
        You can use the "FKFMDBColumn" to generate this array.
 @return `YES` upon success; `NO` upon failure.
 */
- (BOOL)addColumntoTable:(NSString *)tableName columnNameAndTypeArray:(NSArray *)columnNameAndTypeArray;

/* count,sum,avg,max,min
 
 @param 'operation' is a eumn for selectQuery
        You can use the "FKFMDBCondition" to generate the 'condition' or you should type the condition in String.

 @return NSNumber by count,sum,avg,max,min.
 */
- (NSNumber *)queryDataWithOperation:(selectQuery)operation ofColumn:(NSString *)columnName fromTable:(NSString *)tableName withCondition:(NSString *)condition;
@end
