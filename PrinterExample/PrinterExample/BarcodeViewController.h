//
//  BarcodeViewController.h
//  PrinterExample
//
//  Created by 朱正锋 on 27/12/2017.
//  Copyright © 2017 Printer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBComboLabel.h"
#import "StyleButton.h"

@interface BarcodeViewController : UIViewController<UITextFieldDelegate,WBComboLabelDelegate>
@property (nonatomic,strong) IBOutlet WBComboLabel *CboxBarcodeType;
@property (nonatomic,strong) IBOutlet UITextField *barcodeText;
@property (nonatomic,strong) IBOutlet UIImageView *barcodeImage;
@property (nonatomic,strong) IBOutlet UILabel *barcodeCaption;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segRotate;
@property (weak, nonatomic) IBOutlet StyleButton *btnPrint;

@end
