//
//  SearchPrinterListController.h
//  PrinterExample
//
//  Created by king on 2019/10/23.
//  Copyright © 2019年 Printer. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchPrinterListController: BaseTableViewController
@property (strong ,nonatomic) id<SelectDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
