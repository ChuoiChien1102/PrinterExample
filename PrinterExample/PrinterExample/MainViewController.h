//
//  MainViewController.h
//  PrinterExample
//
//  Created by King on 08/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBComboLabel.h"
#import "Printer.h"
#import "WIFIFactory.h"
#import "PinPrinterFactory.h"
#import "ESCFactory.h"
#import "ThermalPrinter.h"
#import "ThermalPrinterFactory.h"
#import "ObserverObj.h"
#import "StyleButton.h"
#import "BleDeviceListController.h"


@interface MainViewController : UITableViewController<WBComboLabelDelegate,UITextFieldDelegate,SelectDelegate>

@property (weak, nonatomic) IBOutlet WBComboLabel *Cboxinstruction;
@property (weak, nonatomic) IBOutlet WBComboLabel *CboxPortType;
@property (weak, nonatomic) IBOutlet UITableView *MainTableView;
@property (strong, nonatomic) NSString *Address;
@property (nonatomic) NSInteger Port;
@property (weak, nonatomic) IBOutlet UILabel *lblChoiceAddress;
@property (weak, nonatomic) IBOutlet StyleButton *btnDisconnect;
@property (weak, nonatomic) IBOutlet StyleButton *btnConnect;
@property (strong, nonatomic) NSTimer * timer1;
@property (strong, nonatomic) IBOutlet StyleButton *btnBarcodeprint;
@property (weak, nonatomic) IBOutlet StyleButton *btntest;
@property (weak, nonatomic) IBOutlet StyleButton *btnTextPrint;
@property (weak, nonatomic) IBOutlet StyleButton *btnImagePrint;
@property (strong, nonatomic) IBOutlet StyleButton *btnBarcodePrint;
@property (weak, nonatomic) IBOutlet StyleButton *btnConnectlist;

@property (weak, nonatomic) IBOutlet StyleButton *btnPrinterStatus;

@property (weak, nonatomic) IBOutlet StyleButton *btnCodepage;

@property (weak, nonatomic) IBOutlet StyleButton *btnPageLength;
@property (weak, nonatomic) IBOutlet UIView *btnDrawBoxPrint;
@property (weak, nonatomic) IBOutlet StyleButton *btnUsbEnabled;
@property (weak, nonatomic) IBOutlet StyleButton *btnBluetootSet;
@property (weak, nonatomic) IBOutlet StyleButton *btnTemplatePrint;
@property (weak, nonatomic) IBOutlet UITableViewCell *tvCellNetPrinter;
@property (weak, nonatomic) IBOutlet StyleButton *btnSearchPrinter;


@end
