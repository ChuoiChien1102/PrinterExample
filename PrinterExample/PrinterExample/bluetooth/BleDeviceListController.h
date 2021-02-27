//
//  BleDeviceListController.h
//  RTPrinter
//
//  Created by PRO on 15/12/20.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "RTDeviceinfo.h"
#import "PrinterInterface.h"



@interface BleDeviceListController : BaseTableViewController

@property BOOL isRefreshing;
@property (strong ,nonatomic) id<SelectDelegate> delegate;
@property (nonatomic) BlueToothKind bluetoothkind;

-(IBAction)refreshDevice:(id)sender;

@end
