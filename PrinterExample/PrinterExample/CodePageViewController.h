//
//  CodePageViewController.h
//  PrinterExample
//
//  Created by 朱正锋 on 12/03/2018.
//  Copyright © 2018 Printer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBComboLabel.h"
#import "StyleButton.h"

@interface CodePageViewController : UIViewController;

@property (weak, nonatomic) IBOutlet UITextField *edtChooseCodePage;
@property (weak, nonatomic) IBOutlet StyleButton *btnSetting;

@end
