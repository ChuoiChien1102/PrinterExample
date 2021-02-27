//
//  BaseTableViewController.m
//  RTPrinter
//
//  Created by PRO on 15/12/28.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController (){
    
}


@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   _printerManager = [PrinterManager sharedInstance];
   UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=NSLocalizedString(@"App_back", nil);
    self.navigationItem.backBarButtonItem=backItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
