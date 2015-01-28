//
//  ViewController.m
//  FKFMDBDemo
//
//  Created by ouok on 1/27/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    _fmdbTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame style:UITableViewStylePlain];
    _fmdbTableView.delegate = self;
    _fmdbTableView.dataSource = self;
    
    _FKDatabase = [[FKFMDatabase alloc] initWithDatabaseName:@"theUser"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    // Configure the cell...
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"createTable";
            break;
        case 1:
            cell.textLabel.text = @"deleteTable";
            break;
        case 2:
            cell.textLabel.text = @"insertData";
            break;
        case 3:
            cell.textLabel.text = @"deleteData";
            break;
        case 4:
            cell.textLabel.text = @"updateData";
            break;
        case 5:
            cell.textLabel.text = @"queryData";
            break;
        case 6:
            cell.textLabel.text = @"alertColumn";
            break;
        case 7:
            cell.textLabel.text = @"count,sum,avg,max,min";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_FKDatabase open];
    switch (indexPath.row) {
        case 0:
        {
            //id
            FKFMDBColumn *setColumn1 = [[FKFMDBColumn alloc] initWithColumn:@"id" andType:isdatabaseTypeinterger];
            setColumn1.primary = YES;
            NSString *columString1 = [setColumn1 buidColumn];
            
            //name
            FKFMDBColumn *setColumn2 = [[FKFMDBColumn alloc] initWithColumn:@"name" andType:isdatabaseTypeTEXT];
            NSString *columString2 = [setColumn2 buidColumn];
            
            //sex
            FKFMDBColumn *setColumn3 = [[FKFMDBColumn alloc] initWithColumn:@"sex" andType:isdatabaseTypeTEXT];
            setColumn3.canNULL = NO;
            NSString *columString3 = [setColumn3 buidColumn];
            
            //age
            FKFMDBColumn *setColumn4 = [[FKFMDBColumn alloc] initWithColumn:@"age" andType:isdatabaseTypeinterger];
            setColumn4.canNULL= NO;
            setColumn4.defaultValue = @"99";
            NSString *columString4 = [setColumn4 buidColumn];
            
            [_FKDatabase createTable:@"testTable1" columnAndTypeStringArray:@[columString1,columString2,columString3,columString4]];
        }
            break;
        case 1:
            [_FKDatabase deleteDataWithCondition:nil fromTable:@"testTable1"];
            break;
        case 2:
        {
            NSMutableArray *array = [NSMutableArray array];
            for (int i=0; i<100; i++) {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjects:@[[NSString stringWithFormat:@"Okar%d",(int)i],@"female",[NSNumber numberWithInteger:22]] forKeys:@[@"name",@"sex",@"age"]];
                [array addObject:dic];
            }
            [_FKDatabase insertDataWithColumDicArray:array intoTable:@"testTable1"];
        }
            break;
        case 3:
            [_FKDatabase deleteDataWithCondition:@"name='Okar'" fromTable:@"testTable1"];
            
            break;
        case 4:
            [_FKDatabase updateDataWithColumDicArray:@[@{@"name":@"OOOOkar",@"age":[NSNumber numberWithInteger:23]}] condition:@"sex='female'" toTable:@"testTable1"];
            break;
        case 5:
        {
            FKFMDBCondition *rsCondition = [FKFMDBCondition new];
            rsCondition.whereCondition = @"sex='female'";
            //            rsCondition.whereCondition = @"name like 'Okar%'";
            //            rsCondition.whereCondition = @"name glob 'Okar?'";
            //            rsCondition.whereCondition = [rsCondition COLUMNNAME:@"name" LIKE:@"Okar%"];
//            rsCondition.andCondition = @[@"idnumber='0123'",[FKFMDBCondition COLUMN:@"name" LIKE:@"Okar%"]];
            //            rsCondition.orCondition = @"idnumber='0123'";
            //            rsCondition.groupbyCondition = @"id";
            //            rsCondition.havingCondition = @"count(id)>14400";
            //            rsCondition.orderbyCondition = @"id desc";
            //            rsCondition.limit = 10;
            //            rsCondition.offset = 100;
            NSLog(@"%@",[_FKDatabase querytheDataWithColumns:@[@"name",@"id",@"sex"] condition:[rsCondition buildCondition] fromTable:@"testTable1"]);
            //            NSLog(@"%@",[_FKDatabase querytheDataWithColumnName:@[@"name",@"sex",@"age"] condition:nil fromTable:@"testTable1"])
        }
            break;
        case 6:
        {
            FKFMDBColumn *setNewColumn1 = [[FKFMDBColumn alloc] initWithColumn:@"phoneNumber" andType:isdatabaseTypeTEXT];
            setNewColumn1.defaultValue = @"12345678";
            
            FKFMDBColumn *setNewColumn2 = [[FKFMDBColumn alloc] initWithColumn:@"idnumber" andType:isdatabaseTypeTEXT];
            setNewColumn2.defaultValue = @"0123";
            
            [_FKDatabase addColumntoTable:@"testTable1" columnNameAndTypeArray:@[[setNewColumn1 buidColumn],[setNewColumn2 buidColumn]]];
        }
            break;
        case 7:
        {
            NSLog(@"count=%@",[_FKDatabase queryDataWithOperation:count ofColumn:@"idnumber" fromTable:@"testTable1" withCondition:nil]);
            NSLog(@"sum=%@",[_FKDatabase queryDataWithOperation:sum ofColumn:@"idnumber" fromTable:@"testTable1" withCondition:nil]);
            NSLog(@"avg=%@",[_FKDatabase queryDataWithOperation:avg ofColumn:@"idnumber" fromTable:@"testTable1" withCondition:nil]);
            NSLog(@"max=%@",[_FKDatabase queryDataWithOperation:max ofColumn:@"idnumber" fromTable:@"testTable1" withCondition:nil]);
            NSLog(@"min=%@",[_FKDatabase queryDataWithOperation:min ofColumn:@"idnumber" fromTable:@"testTable1" withCondition:nil]);
        }
            break;
        default:
            break;
    }
    [_FKDatabase close];
}


@end
