//
//  BluetoothSetting.m
//  PrinterExample
//
//  Created by 朱正锋 on 2018/9/19.
//  Copyright © 2018年 Printer. All rights reserved.
//

#import "BluetoothSettingController.h"
#import "PrinterManager.h"
#import "PlistUtils.h"
@implementation BluetoothSettingController
{
    PrinterManager * _printerManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _printerManager = PrinterManager.sharedInstance;
    _TxtBleTranSize.text = [NSString stringWithFormat:@"%d",_printerManager.MTULength];
    _TxtBleTransinterval.text = [NSString stringWithFormat:@"%d",_printerManager.SendDelayMS];
  //  self.cboxblewritetype.delegate = self;
    _cboxblewritetype.currentIndex = _printerManager.CurrentPrinter.blewritetype;
}
- (IBAction)btnSave:(id)sender {
    //self.btnBleTranSize.text
    int MtuLen = [self.TxtBleTranSize.text intValue];
    int SendDelayMs = [self.TxtBleTransinterval.text intValue];
    [_printerManager SetBluetoothSize:MtuLen iSendDelayMS:SendDelayMs];
    _printerManager.CurrentPrinter.blewritetype =
    (BleWriteType)_cboxblewritetype.currentIndex;
    [PlistUtils saveIntConfig:@"MTULength" value:MtuLen];
    [PlistUtils saveIntConfig:@"SendDelayMS" value:SendDelayMs];
    [PlistUtils saveIntConfig:@"BleWritetype" value:_cboxblewritetype.currentIndex];
    

}

-(void)WBComboValueChanged:(id)sender{
//    _printerManager.CurrentPrinter.blewritetype =
//    (BleWriteType)_cboxblewritetype.currentIndex;
    //.CurrentPrinterCmdType = (PrinterCmdType)_Cboxinstruction.currentIndex;
}


@end
