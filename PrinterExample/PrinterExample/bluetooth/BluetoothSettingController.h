//
//  BluetoothSetting.h
//  PrinterExample
//
//  Created by 朱正锋 on 2018/9/19.
//  Copyright © 2018年 Printer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WBComboLabel.h"
#import "StyleButton.h"

@interface BluetoothSettingController :UIViewController;
@property (weak, nonatomic) IBOutlet UITextField *TxtBleTranSize;

@property (weak, nonatomic) IBOutlet UITextField *TxtBleTransinterval;
@property (weak, nonatomic) IBOutlet WBComboLabel *cboxblewritetype;


@end
