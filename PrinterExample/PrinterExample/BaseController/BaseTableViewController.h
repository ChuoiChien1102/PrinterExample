//
//  BaseTableViewController.h
//  RTPrinter
//
//  Created by PRO on 15/12/28.
//  Copyright © 2015年 bluedrum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PrinterManager.h"

@interface BaseTableViewController : UITableViewController
 {
    PrinterManager * _printerManager;
}

@end
