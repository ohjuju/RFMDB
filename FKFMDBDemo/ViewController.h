//
//  ViewController.h
//  FKFMDBDemo
//
//  Created by ouok on 1/27/15.
//  Copyright (c) 2015 ouok. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FKFMDatabase.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *fmdbTableView;
@property (nonatomic, strong) FKFMDatabase *FKDatabase;

@end

